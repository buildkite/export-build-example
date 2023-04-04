#!/bin/bash

slug_list=()
page=1
pipeline_length=1
state="$1"
valid_states=("running" "scheduled" "passed" "failing" "failed" "blocked" "canceled" "canceling" "skipped" "not_run" "finished")

# Validate input values for state parameter
if [[ ! " ${valid_states[@]} " =~ " $state " ]]; then
  echo "Invalid input state: $state. Valid states are: ${valid_states[@]}"
  exit 1
fi

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

 # Create Folder for Artifact
  if [ -d "pipelines/" ]; then
        rm -r pipelines
  fi
  mkdir pipelines
 
# Loop through the pipeline slug list and get list of builds for each pipeline slug
for slug in "${slug_list[@]}"; do
    page=1
    build_length=30

    while [ "${build_length}" -ne 0 ];do

        # Set the list build endpoint URL for the current pipeline slug
        api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/$slug/builds?page=${page}"

        if [ ! -f "$state" ]; then
          api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/$slug/builds?state=${state}&page=${page}"
        fi

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
          rm  pipelines_${slug}-${page}.json
        fi

        # Copy Artifact to Folder
        if [ "$outputType" == "artifact" ]; then
             # Copy file to Artifact Folder
              cp pipelines_"${slug}-${page}".json pipelines/
        fi
        page=$((page + 1))
    done
done

# Upload Artifact to S3 Bucket
  if [ "$outputType" == "artifact" ]; then
      # Upload Artifacts
      buildkite-agent artifact upload "pipeline*"
  fi
