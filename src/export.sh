#!/bin/bash

slug_list=()

# Make the curl request to get list of pipelines
api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines"
response_status=$(curl -s -H "Authorization: Bearer $TOKEN" -w "%{http_code}" -o "pipelines.json" "$api_url")

# Check if the response code is 200 OK
if [ "$response_status" -ne 200 ]; then
  echo "Error: API call failed with HTTP status code $response_status"
  exit 1
fi

# Extract the slug values from the response and add them to the slug list
if ! slugs=$(jq -r '.[].slug' < "pipelines.json"); then
  echo "Error: Failed to extract pipeline slug values"
  exit 1
fi

# Create a list with all the pipeline slugs
slug_list+=("${slugs// /}")

# Loop through the pipeline slug list and get list of builds for each pipeline slug
for slug in "${slug_list[@]}"; do
    # Set the list build endpoint URL for the current pipeline slug
    api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/$slug/builds"

    # Make the API request with curl and generate builds per pipeline in a file
    response_status=$(curl -s -H "Authorization: Bearer $TOKEN" -w "%{http_code}" -o "pipelines_${slug}.json" "$api_url")

    # Check if the response code is 200 OK
    if [ "$response_status" -ne 200 ]; then
       echo "Error: Failed to get build data from API with HTTP status code $response_status"
       exit 1
    fi
done
