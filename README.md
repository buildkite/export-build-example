# export-build-example
A pipeline template example to export builds via the API, stores the results as JSON file

This repository is an example [Buildkite](https://buildkite.com/) pipeline for running scripts to get Build data to be stored S3 Bucket, Artifact, or to the Local Machine 

The scripts in the src/ folder, can be used for:
* Get Files Locally: /src/export.sh
* Upload to S3 Bucket: /src/export_s3.sh
* Upload as Artifact: /src/export_artifact.sh

## Steps for running on Local Machine
git clone https://github.com/buildkite/export-build-example.git <br/>
cd into folder  <br/>
Enter "./src/export.sh" or ".src/export_s3.sh" depending on where JSON file is to be stored <br/>
```

## Examples
### Get Files Locally
To export the build data for all pipelines to local machine
```yml
steps:
  - label: "export build data to Local Machine"
    command: ./src/export.sh
```

### Upload Files to S3 Bucket
To  export the build data for all pipelines to an S3 Bucket

#### Requirement
* awscli 
* s3 bucket

```yml
steps:
  - label: "export build data to S3 Bucket"
    command: ./src/export_s3.sh
```


### Get Files as Artifact

To export the build data for all pipelines as an artifact
```yml
steps:
  - label: "export build data as Artifact"
    command: ./src/export_artifact.sh
```
Note: This won't work, when running scripts through local machine

## License

See [License.md](License.md) (MIT)
