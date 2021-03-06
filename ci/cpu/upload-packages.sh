#!/bin/bash
# Copyright (c) 2018, NVIDIA CORPORATION.

# Restrict uploads to master branch
if [[ "${GIT_BRANCH}" != "master" ]]; then
  echo "Skipping upload"
  return 0
fi

if [ -z "$MY_UPLOAD_KEY" ]; then
    echo "No upload key"
    return 0
fi

anaconda -t ${MY_UPLOAD_KEY} upload -u ${CONDA_USERNAME:-rapidsai} --label main --force "`conda build conda/recipes/jupyterlab-nvdashboard --output`"

echo '//registry.npmjs.org/:_authToken=${NPM_TOKEN}' > .npmrc
if [[ "$BUILD_MODE" == "branch" && "${SOURCE_BRANCH}" != 'master' ]]; then
  echo "Nightly build, publishing to npm with nightly tag"
  npm publish --tag=nightly
else
  npm publish
fi