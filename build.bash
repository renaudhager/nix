#!/usr/bin/env bash

OUTPUT_DIR=".artefacts"
COMPONENT_DIR="components"

for c in `ls ${COMPONENT_DIR}`
do
    filename=`basename $c`
    component=${filename%%.*}
    echo "Building $component"
    nix-build ${COMPONENT_DIR}/$filename --out-link ${OUTPUT_DIR}/${component%%.*}
done