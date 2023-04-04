#!/bin/bash

slug_list=()
page=1
pipeline_length=1
query=""
valid_states=("running" "scheduled" "passed" "failing" "failed" "blocked" "canceled" "canceling" "skipped" "not_run" "finished")

if [ -d "pipelines/" ]; then
    rm -r pipelines
fi
mkdir pipelines

# Function to print script usage information
usage() {
  echo "Usage: $0 -p <pipeline_slug> -s <build_state> -f <created_from> -t <created_to> -e <outputType>"
  echo "Options:"
  echo "  -p    Slug of pipeline you want to export. If you want to export all pipelines then no need to use -p flag"
  echo "  -s    Filter by state of build"
  echo "  -f    Filter by created_from"
  echo "  -t    Filter by created_to"
  echo "  -e    Select Export Platform Type"
}

# flags for input parameters
while getopts "hp:s:f:t:e:" opt; do
  case $opt in
    h)
      usage
      exit 0
      ;;
    p)
      pipeline_slug=$OPTARG
      ;;
    s)
      state=$OPTARG
      ;;
    f)
      created_from=$OPTARG
      ;;
    t)
      created_to=$OPTARG
      ;;
    e)
      outputType=$OPTARG
      ;;
    \?)
      echo "Invalid option" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done

# Validate input values for created_from and created_to
function validate_date_range() {
  local from=$1
  local to=$2

  if [[ $created_from != "" && $created_to == "" ]] || [[ $created_from == "" && $created_to != "" ]]; then
    echo "Error: Both created_to and created_from are required when one of them is set for exporting data for a time interval"
    usage
    exit 1
  elif ! [[ "$from" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || ! [[ "$to" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Invalid input: Dates must be in the format of YYYY-MM-DD for created_from and created_to filters"
    exit 1
  elif [[ "$from" > "$to" ]]; then
    echo "Invalid date range: 'created_from' date should be earlier than 'created_to' date."
    exit 1
  fi
}

# Validate and generate the query parameters for time range filter
if [ -n "$created_from" ] || [ -n "$created_to" ]; then
  validate_date_range "$created_from" "$created_to"
  query+="created_from=${created_from}&created_to=${created_to}&"
fi

# Validate input value for state parameter
if [ -z "$state" ]; then
    echo "Going to fetch builds with any status"
else 
  for i in "${valid_states[@]}"; do
    if [ "$i" == "$state" ] ; then
      query+="state=${state}&"
      FOUND=1
      break
    fi
  done
  if [ "${FOUND:-0}" == "0" ]; then
    echo "Invalid input state: $state. Valid states are: ${valid_states[*]}"
    exit 1 
  fi
fi

if [ -z "$pipeline_slug" ]; then
  # Make the curl request to get list of pipelines
  api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines"

  while [ "${pipeline_length}" -ne 0 ];do
    response_status=$(curl -s -H "Authorization: Bearer $TOKEN" -w "%{http_code}" -o "pipelines-${page}.json" "${api_url}?page=${page}")

    # Check if the response code is 200 OK
    if [ "$response_status" -ne 200 ]; then
      echo "Error: API call failed with HTTP status code $response_status"
      exit 1
    fi

    # Check if more pipelines exist
    pipeline_length=$(jq -r '. | length' "pipelines-${page}.json")

    # Extract the slug values from the response and add them to the slug list
    if ! slugs=$(jq -r '.[].slug' pipelines-${page}.json); then
      echo "Error: Failed to extract pipeline slug values"
      exit 1
    fi

    # Check for empty file and remove it
    if [ "${pipeline_length}" -eq 0 ]; then
      rm  pipelines-${page}.json
    fi

    # Create a list with all the pipeline slugs
    slug_list+=($slugs)

    page=$((page + 1))
  done
fi

slug_list+=($pipeline_slug)

# Loop through the pipeline slug list and get list of builds for each pipeline slug
for slug in "${slug_list[@]}"; do
    page=1
    build_length=1
    echo "Fetching list of builds for pipeline $slug"
    while [ "${build_length}" -ne 0 ];do

        # Set the list build endpoint URL for the current pipeline slug
        api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/$slug/builds?${query}page=${page}"

        # Make the API request with curl and generate builds per pipeline in a file
        response_status=$(curl -s -H "Authorization: Bearer $TOKEN" -w "%{http_code}" -o "pipelines_${slug}-${page}.json" "${api_url}")

        # Check if the response code is 200 OK
        if [ "$response_status" -ne 200 ]; then
          echo "Error: Failed to get build data from API with HTTP status code $response_status"
          exit 1
        fi

        build_length=$(jq -r '. | length' "pipelines_${slug}-${page}.json")

        # Check for empty file and remove it
        if [ "${build_length}" -eq 0 ]; then
          rm  pipelines_"${slug}-${page}".json
        else
          # Move files to Folder
            mv pipelines_"${slug}-${page}".json pipelines/
        fi
        page=$((page + 1))
    done
    echo "Generated file with build history for pipeline $slug"
done

# Checks which platform files should be exported to
function external_export_format() {
   # Copy to files to User Defined S3 Bucket
    if [ "$outputType" == "bucket" ]; then
        # Upload the pipeline and builds data files to User S3 bucket
        aws s3 sync "pipelines/" s3://"$my_bucket_name"/
    fi
   
  # Upload Artifact to S3 Bucket
   if [ "$outputType" == "artifact" ]; then
      # Upload Artifacts
      buildkite-agent artifact upload "pipelines/*"
   fi
}
external_export_format "$outputType"
