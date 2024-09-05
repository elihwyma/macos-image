#!/bin/bash

echo "Building All Images"
# Loop through templates
for template in $(ls templates); do
  echo "Building $template"
  packer build templates/$template
done
