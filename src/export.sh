#!/bin/bash

slug_list=()

# Make the curl request to get list of pipelines
api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines"
response=$(curl -s -H "Authorization: Bearer $TOKEN" $api_url)

# Check if the response is empty or if it contains an error message
if [[ -z "$response" || "$response" == *"error"* ]]; then
    echo "Error: Failed to get pipeline data $response"
    exit 1
fi

# Process the response data
echo "$response" >> pipelines.json

# Extract the slug values from the response and add them to the slug list
slugs=$(echo "$response" | jq -r '.[].slug')
slug_list+=($slugs)
    
# Loop through the pipeline slug list and get list of builds for each pipeline slug
for slug in "${slug_list[@]}"; do
    # Set the list build endpoint URL for the current pipeline slug
    api_url="https://api.buildkite.com/v2/organizations/$BUILDKITE_ORGANIZATION_SLUG/pipelines/$slug/builds"
    
    # Make the API request with curl and do something with the response
    response=$(curl -s -H "Authorization: Bearer $TOKEN" $api_url)
    # Check if the response is empty or if it contains an error message
    if [[ -z "$response" || "$response" == *"error"* ]]; then
       echo "Error: Failed to get build data $response"
       exit 1
    fi
    # Process the response data
    echo "$response" >> pipelines_$slug.json
done
