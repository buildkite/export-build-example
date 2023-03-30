# export-build-example
A pipeline template example to export builds via the API

This repository is an example [Buildkite](https://buildkite.com/) pipeline for running scripts to get Build data to be stored S3 Bucket, Artifact, or to the Local Machine 

## Get Files Locally
### Example

In this example, we would export the build data for all pipelines to local machine
```yml
steps:
  - label: "export build data to Local Machine"
    command: ./src/export.sh
```

## Upload Files to S3 Bucket
### Example
In this example, we would export the build data for all pipelines to S3 Bucket
```yml
steps:
  - label: "export build data to S3 Bucket"
    command: ./src/export_s3.sh
```


## Get Files as Artifact
### Example
In this example, we would export the build data for all pipelines as an artifact
```yml
steps:
  - label: "export build data as Artifact"
    command: ./src/export_artifact.sh
```
## License

See [License.md](License.md) (MIT)
