#!/bin/bash

MACOS_VERSION=14.3

# Run for sonoma-m1 and sonoma-m1-unity
for machine in sonoma-m1 sonoma-m1-unity; do
  echo "Running for $machine"
  # Repeat until result 0
  while true; do
    echo "Uploading $machine to ghcr.io/elihwyma/$machine:$MACOS_VERSION"
    tart push $machine ghcr.io/elihwyma/$machine:$MACOS_VERSION
    if [ $? -eq 0 ]; then
      break
    else
      echo "Upload failed, retrying..."
    fi
  done
done