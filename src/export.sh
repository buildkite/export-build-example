#!/bin/bash

slug_list=()

# Make the curl request to get list of pipelines
api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines"
echo "Fetching list of pipelines in $BUILDKITE_ORGANIZATION_SLUG org"

# Loop through the pagination links
while [ "$api_url" != "" ]; do
    response_status=$(curl -s -H "Authorization: Bearer $TOKEN" -w "%{http_code}" -o "response.json" "$api_url")

    # Check if the response code is 200 OK
    if [ "$response_status" -ne 200 ]; then
      echo "Error: API call failed with HTTP status code $response_status"
      exit 1
    fi   
    
    # Append output to a file and prettify it
    if [ -s response.json ]; then
      jq '.' response.json >> pipelines.json   
    fi
    rm response.json

    # Get the URL of the next page from the Link header
    api_url=$(curl -s -I -H "Authorization: Bearer $TOKEN" "$api_url" | grep -o -E '<([^>]*)>; rel="next"' | sed -E 's/<(.*)>; rel="next"/\1/')
done

# Extract the slug values from the response and add them to the slug list
if ! slugs=$(jq -r '.[].slug' < "pipelines.json"); then
    echo "Error: Failed to extract pipeline slug values"
    exit 1
fi
slug_list+=($slugs) 

# Loop through the pipeline slug list and get list of builds for each pipeline slug
for slug in "${slug_list[@]}"; do

    # Set the list build endpoint URL for the current pipeline slug
    api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/$slug/builds"
    
    echo "Fetching list of builds for pipeline $slug"

    # Loop through the pagination links
    while [ "$api_url" != "" ]; do

      response=$(curl -s -H "Authorization: Bearer $TOKEN" "$api_url" -o response.json -w "%{http_code}")

      # Check if the response code is 200 OK
      if [ "$response" -ne 200 ]; then
        echo "Error: API call to fetch builds failed with HTTP status code $response"
        exit 1
      fi 

      # Append output to a file and prettify it
      if [ -s response.json ]; then
        jq '.' response.json >> pipeline_${slug}.json    
      fi

      # Get the URL of the next page from the Link header
      api_url=$(curl -s -I -H "Authorization: Bearer $TOKEN" "$api_url" | grep -o -E '<([^>]*)>; rel="next"' | sed -E 's/<(.*)>; rel="next"/\1/')

    done

    # Prettify the build output JSON file
    if [ -s pipeline_${slug}.json ]; then
      echo "Generated file pipeline_${slug}.json with build history for pipeline $slug"
      rm response.json
    fi

done
