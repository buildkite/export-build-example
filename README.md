# Pipeline Template Example: Export Builds
<!--
[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new)
-->
A pipeline template example to export builds via the API, stores the results as JSON file

This repository is an example [Buildkite](https://buildkite.com/) pipeline for running scripts to get build data exported to S3 Bucket or to the Local Machine for a default period of last 90 days

Note: $TOKEN is the [User API Access Token](https://buildkite.com/user/api-access-tokens). It can be set in the environment hook in .git/hooks/environment or using any methods in [managing pipeline secrets](https://buildkite.com/docs/pipelines/secrets#main)

Below is an example of what the build data for a specific build for a pipeline will contain when exported using this export builds pipeline. Note that default the build data won't include `retried jobs`

```
{
    "id": "0187a5d8-c259-484d-b1af-9c0312e94482",
    "graphql_id": "QnVpbGQtLS0wMTg3YTVkOC1jMjU5LTQ4NGQtYjFhZi05YzAzMTJlOTQ0ODI=",
    "url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline/builds/1106",
    "web_url": "https://buildkite.com/my-great-org/my-pipeline/builds/1106",
    "number": 1106,
    "state": "passed",
    "blocked": false,
    "blocked_state": "",
    "message": "Update curl.sh",
    "commit": "ec1bfcf8f9404858257271b05503eecbebd7bc0a",
    "branch": "master",
    "tag": null,
    "env": {},
    "source": "ui",
    "author": null,
    "creator": {
        "id": "cae17533-af72-406a-8a54-099e3deb2fc7",
        "graphql_id": "VXNlci0tLWNhZTE3NTMzLWFmNzItNDA2YS04YTU0LTA5OWUzZGViMmZjNw==",
        "name": "Keith Pitt",
        "email": "keith@buildkite.com",
        "avatar_url": "https://www.gravatar.com/avatar/ae0aa01500aaef540c81d4315e86fe4b",
        "created_at": "2021-10-11T22:41:14.705Z"
    },
    "created_at": "2023-04-21T22:04:18.920Z",
    "scheduled_at": "2023-04-21T22:04:18.857Z",
    "started_at": "2023-04-21T22:04:20.291Z",
    "finished_at": "2023-04-21T22:04:23.798Z",
    "meta_data": {
        "buildkite:git:commit": "commit ec1bfcf8f9404858257271b05503eecbebd7bc0a\n"
    },
    "pull_request": null,
    "rebuilt_from": null,
    "pipeline": {
        "id": "18674611-205a-42f9-97ad-1aa1a3bd2a1b",
        "graphql_id": "UGlwZWxpbmUtLS0xODY3NDYxMS0yMDVhLTQyZjktOTdhZC0xYWExYTNiZDJhMWI=",
        "url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline",
        "web_url": "https://buildkite.com/my-great-org/my-pipeline",
        "name": "my-pipeline",
        "description": "Learning to :pipeline: is fun.",
        "slug": "my-pipeline",
        "repository": "git@github.com:my-great-org/my-pipeline",
        "cluster_id": null,
        "branch_configuration": "",
        "default_branch": "master",
        "skip_queued_branch_builds": false,
        "skip_queued_branch_builds_filter": null,
        "cancel_running_branch_builds": false,
        "cancel_running_branch_builds_filter": null,
        "allow_rebuilds": true,
        "provider": {
            "id": "github",
            "settings": {
                "trigger_mode": "code",
                "build_pull_requests": true,
                "pull_request_branch_filter_enabled": false,
                "skip_builds_for_existing_commits": false,
                "skip_pull_request_builds_for_existing_commits": false,
                "build_pull_request_ready_for_review": false,
                "build_pull_request_labels_changed": false,
                "build_pull_request_base_branch_changed": false,
                "build_pull_request_forks": false,
                "prefix_pull_request_fork_branch_names": true,
                "build_branches": true,
                "build_tags": true,
                "cancel_deleted_branch_builds": false,
                "publish_commit_status": true,
                "publish_commit_status_per_step": true,
                "separate_pull_request_statuses": false,
                "publish_blocked_as_pending": false,
                "use_step_key_as_commit_status": false,
                "filter_enabled": false,
                "repository": "my-great-org/my-pipeline",
                "pull_request_branch_filter_configuration": "",
                "filter_condition": "build.message !~ /skip/"
            },
            "webhook_url": "https://webhook.buildkite.com/deliver/d4152a14d56c9b30a1b1b8c992e2f15a2da970262793e5f6fc"
        },
        "builds_url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline/builds",
        "badge_url": "https://badge.buildkite.com/b4f0a68c4e1f2ea57f43adb71b33586b8e10347ac463362687.svg",
        "created_by": {
            "id": "cae17533-af72-406a-8a54-099e3deb2fc7",
            "graphql_id": "VXNlci0tLWNhZTE3NTMzLWFmNzItNDA2YS04YTU0LTA5OWUzZGViMmZjNw==",
            "name": "Keith Pitt",
            "email": "keith@buildkite.com",
            "avatar_url": "https://www.gravatar.com/avatar/ae0aa01500aaef540c81d4315e86fe4b",
            "created_at": "2021-10-11T22:41:14.705Z"
        },
        "created_at": "2021-11-17T02:19:33.520Z",
        "archived_at": null,
        "env": null,
        "scheduled_builds_count": 0,
        "running_builds_count": 0,
        "scheduled_jobs_count": 0,
        "running_jobs_count": 1,
        "waiting_jobs_count": 0,
        "visibility": "private",
        "tags": [
            ":test: Repo"
        ],
        "emoji": null,
        "color": null,
        "configuration": "steps:\n  - command: buildkite-agent env set foo=bar\n  - command: buildkite-agent env get foo",
        "steps": [
            {
                "type": "script",
                "name": null,
                "command": "buildkite-agent env set foo=bar",
                "artifact_paths": null,
                "branch_configuration": null,
                "env": {},
                "timeout_in_minutes": null,
                "agent_query_rules": [],
                "concurrency": null,
                "parallelism": null
            },
            {
                "type": "script",
                "name": null,
                "command": "buildkite-agent env get foo",
                "artifact_paths": null,
                "branch_configuration": null,
                "env": {},
                "timeout_in_minutes": null,
                "agent_query_rules": [],
                "concurrency": null,
                "parallelism": null
            }
        ]
    },
    "jobs": [
        {
            "id": "0187a5d8-c266-4639-a7e3-719ebc4cbd0c",
            "graphql_id": "Sm9iLS0tMDE4N2E1ZDgtYzI2Ni00NjM5LWE3ZTMtNzE5ZWJjNGNiZDBj",
            "type": "script",
            "name": null,
            "step_key": null,
            "priority": {
                "number": 0
            },
            "agent_query_rules": [],
            "state": "passed",
            "build_url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline/builds/1106",
            "web_url": "https://buildkite.com/my-great-org/my-pipeline/builds/1106#0187a5d8-c266-4639-a7e3-719ebc4cbd0c",
            "log_url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline/builds/1106/jobs/0187a5d8-c266-4639-a7e3-719ebc4cbd0c/log",
            "raw_log_url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline/builds/1106/jobs/0187a5d8-c266-4639-a7e3-719ebc4cbd0c/log.txt",
            "artifacts_url": "https://api.buildkite.com/v2/organizations/my-great-org/pipelines/my-pipeline/builds/1106/jobs/0187a5d8-c266-4639-a7e3-719ebc4cbd0c/artifacts",
            "command": "echo \"test\"",
            "soft_failed": false,
            "exit_status": 0,
            "artifact_paths": null,
            "created_at": "2023-04-21T22:04:18.896Z",
            "scheduled_at": "2023-04-21T22:04:18.896Z",
            "runnable_at": "2023-04-21T22:04:18.986Z",
            "started_at": "2023-04-21T22:04:20.291Z",
            "finished_at": "2023-04-21T22:04:23.708Z",
            "expired_at": null,
            "retried": false,
            "retried_in_job_id": null,
            "retries_count": null,
            "retry_source": null,
            "retry_type": null,
            "parallel_group_index": null,
            "parallel_group_total": null,
            "matrix": null,
            "agent": {
                "id": "0187a5d5-f4b9-406c-bedf-25f4025e0724",
                "url": "https://api.buildkite.com/v2/organizations/my-great-org/agents/0187a5d5-f4b9-406c-bedf-25f4025e0724",
                "web_url": "https://buildkite.com/organizations/my-great-org/agents/0187a5d5-f4b9-406c-bedf-25f4025e0724",
                "name": "my-agent",
                "connection_state": "disconnected",
                "ip_address": "98.237.157.13",
                "hostname": "localhost",
                "user_agent": "buildkite-agent/3.39.0.4570 (darwin; arm64)",
                "version": "3.39.0",
                "creator": null,
                "created_at": "2023-04-21T22:01:15.193Z",
                "job": null,
                "last_job_finished_at": "2023-04-21T22:04:23.713Z",
                "priority": 0,
                "meta_data": [
                    "queue=default"
                ]
            }
        }
    ]
}
```

## Adding Filters
Usage ./src/export.sh -p <pipeline_slug> -s <build_state> -f <created_from> -t <created_to> -b <bucket_name>

| Flag Options  |  Usage      
| ------------- | ------------- 
| ` -p `        | Filter by pipeline_slug       
| ` -s `        | Filter by Build State   
| ` -f `        | Filter by Date/Time using API Parameter created_from     
| ` -t `        | Filter by Date/Time using API Parameter created_to    
| ` -b `        | S3 bucket name 
       
* The two attributes [created_from](https://buildkite.com/docs/apis/rest-api/builds#list-all-builds) & [created_to](https://buildkite.com/docs/apis/rest-api/builds#list-all-builds) are used to specify the date range. If date range is not provided it will default to last 90 days 
* Check Buildkite Valid [Build States](https://buildkite.com/docs/pipelines/defining-steps#build-states)
* To export archieved files to S3 bucket use -b flag and pass bucket information

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



