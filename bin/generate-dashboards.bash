#!/bin/bash
set -ex

mkdir -p tmp

cp stubs/dashboards-configmap.yaml tmp/configmap.yaml
cp stubs/dashboards-lovelace.yaml tmp/lovelace.yaml

for dash in $(ls dashboards/*.yaml); do
  u=$(basename $dash | cut -f 1 -d .)
  t=$(echo $u | tr - ' ')
  f=$(echo $u | tr '[:upper:]' '[:lower:]')
  i=$(basename $dash | cut -f 2 -d .)

  cp stubs/dashboard-record.yaml tmp/$f.yaml
  yq -i ".title=\"${t}\"" tmp/$f.yaml
  yq -i ".icon=\"mdi:${i}\"" tmp/$f.yaml
  yq -i ".filename=\"${f}.yaml\"" tmp/$f.yaml

  yq -i ".dashboards.\"${f}-yaml\" = load(\"tmp/$f.yaml\")" tmp/lovelace.yaml

  yq -i ".data.\"${f}.yaml\" = load_str(\"$dash\")" tmp/configmap.yaml
done

yq ".data.\"lovelace.yaml\" = load_str(\"tmp/lovelace.yaml\")" tmp/configmap.yaml > resources/dashboards.yaml

rm -r tmp/
