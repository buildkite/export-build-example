# export-build-example
A pipeline template example to export builds via the API

This repository is an example [Buildkite](https://buildkite.com/) pipeline for running a script to get Build data to be stored S3 Bucket, Artifact, or Local Machine 

The script simply prints some debug output with an inline image, some artifacts, and exits with a success code (0).

## Get Files Locally
### Example

```yml
steps:
  - label: "export build data"
    command: ./src/export.sh
```

## Upload Files to S3 Bucket
### Example

```yml
steps:
  - label: "export build data"
    command: ./src/export_s3.sh
```


## Get Files as Artifact
### Example

```yml
steps:
  - label: "export build data"
    command: ./src/export_artifact.sh
```
## License

See [License.md](License.md) (MIT)
