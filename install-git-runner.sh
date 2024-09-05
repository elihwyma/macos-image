#!/bin/bash

RUNNER_VERSION=2.319.1

source ~/.zprofile
echo 'Installing Git Runner Firmware'
mkdir actions-runner && cd actions-runner
curl -o actions-runner-osx-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-osx-arm64-${RUNNER_VERSION}.tar.gz # && tar xzf ./actions-runner-osx-arm64-${RUNNER_VERSION}.tar.gz