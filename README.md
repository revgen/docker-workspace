# 🐳 [Docker Image with DEV environment](https://hub.docker.com/r/rev9en/workspace)

[![Build Docker Image](https://github.com/revgen/docker-workspace/actions/workflows/docker.yml/badge.svg)](https://github.com/revgen/docker-workspace/actions/workflows/docker.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[Docker image](https://hub.docker.com/r/rev9en/workspace) with developer environment, based on Ubuntu Linux 22.04.

It contains:

* Python v3.12
* Node.js v22
* Java v17
* GoLang v1.22
* aws-cli, oci-cli, azure-cli, gcloud-cli

## Usage
Launch docker container with workspace:

```bash
session_dir=${HOME}/.local/share/docker-workspace/${USER}-session
mkdir -p ${session_dir}
docker run -it --rm \
    -p 8000-8999:8000-8999 \
    -v "${session_dir}":/home/shared \
    --name=workspace rev9en/workspace
```

If you want to use docker inside the docker image, add a ```--privileged``` parameter into the ```docker run``` command.
