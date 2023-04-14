# Pipeline Template Example: Export Builds
<!--
[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new)
-->
A pipeline template example to export builds via the API, stores the results as JSON file

This repository is an example [Buildkite](https://buildkite.com/) pipeline for running scripts to get build data exported to S3 Bucket or to the Local Machine for a default period of last 90 days

Note: $TOKEN is the [User API Access Token](https://buildkite.com/user/api-access-tokens). It can be set in the environment hook in .git/hooks/environment or using any methods in [managing pipeline secrets](https://buildkite.com/docs/pipelines/secrets#main)


## Adding Filters
Usage ./src/export.sh -p <pipeline_slug> -s <build_state> -f <created_from> -t <created_to>"

| Flag Options  |  Usage      
| ------------- | ------------- 
| ` -p `        | Filter by pipeline_slug       
| ` -s `        | Filter by Build State   
| ` -f `        | Filter by Date/Time using API Parameter created_from     
| ` -t `        | Filter by Date/Time using API Parameter created_to    
| ` -b `        | S3 bucket name 
       
* The two attributes [created_from](https://buildkite.com/docs/apis/rest-api/builds#list-all-builds) & [created_to](https://buildkite.com/docs/apis/rest-api/builds#list-all-builds) are used to specify the date range. If date range is not provided it will default to last 90 days 
* Check Buildkite Valid [Build States](https://buildkite.com/docs/pipelines/defining-steps#build-states)

## Examples
### Get Files Locally
This example is used to export the passed builds data for all pipelines to the local machine, for a certain timeline

Format:
```
./src/export.sh -s <build_state> -f <created_from> -t <created_to>"
```

#### **`pipeline.yml`**
```yml
steps:
  - label: "export build data to Local Machine"
    command: ./src/export.sh -s passed -f 2023-03-25 -t 2023-03-28
```
The files can be accessed on the local machine from the Builds directory ../buildkite-agent/builds. The respective pipeline folder contains the JSON files for each pipeline in the organization

### Upload Files to S3 Bucket
In this example, the build data for a pipeline is exported to the User's S3 Bucket.

**Note:** You need to use flag **"-b"**, and the value must be "**bucket name**"

Format:

```
./src/export.sh -p <pipeline_slug> -s <build_state> -f <created_from> -t <created_to> -b <bucket_name>
```

#### **`pipeline.yml`**
```yml
steps:
  - label: "export build data to S3 bucket"
    command: ./src/export.sh -p pipeline_slug -s passed -f 2023-03-25 -t 2023-03-28 -b bucketinfo
```

#### Requirement
* Use -b flag to enter the S3 bucket info
* awscli 
* s3 bucket


## License

See [License.md](License.md) (MIT)



