#!/usr/bin/env bash
docker run -it --rm -v "${PWD}:/workdir" -v "$HOME/.ssh:/root/.ssh" -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/basecamp/kamal:v2.7.0 $@

# docker run -it --rm -v "${PWD}:/workdir" -v "${SSH_AUTH_SOCK}:/ssh-agent" -v /var/run/docker.sock:/var/run/docker.sock -e "SSH_AUTH_SOCK=/ssh-agent" ghcr.io/basecamp/kamal:v2.7.0 $@

# docker run -it --rm -v "${PWD}:/workdir" -v "${SSH_AUTH_SOCK}:/ssh-agent" -v /var/run/docker.sock:/var/run/docker.sock -e "SSH_AUTH_SOCK=/ssh-agent" ghcr.io/basecamp/kamal:v2.7.0 $@

