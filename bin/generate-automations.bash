#!/bin/bash

# this script reads in all the yaml files in home-assistant/automations
# and outputs a single yaml list object with no key,
# and writes the result to home-assistant/.list.yaml

# then it reads home-assistant/.list.yaml as a single string
# and injects it into the automations.yaml field of
# home-assistant/automations-yaml.partial.yaml

# all you should need to do this is bash and yq
# https://github.com/mikefarah/yq

mkdir -p tmp/

cmd="yq -n '["
sep=
for yaml in $(ls automations/*.yaml); do
    cmd="${cmd}${sep} load(\"${yaml}\")"
    sep=,
done
cmd="${cmd}]' > tmp/list.yaml"

eval $cmd

yq ".data.\"automations.yaml\" = load_str(\"tmp/list.yaml\")" stubs/automations-configmap.yaml > resources/automations.yaml
rm tmp/list.yaml
