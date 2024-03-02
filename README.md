# homelab-home-assistant

This is a mirco-services repo for deploying
[home-assistant](https://home-assistant.io)
into [my homelab](https://github.com/charlesthomas/homelab).

## automations are a pain

they have to be loaded in via a file that's referenced in the main config

that main config is in a configmap, and so are the automations

but making a single configmap that's an enourmous blob b/c it's two text files is
supremely unweildy

instead, every time you make a new automation, extract it out of home-assistant, and store
it in a yaml file in `automations/`.

then run `./generate-automations.sh`, and it will
generate a single yaml list from each of the individual automations files.
then it will load that list as a string value into the appropriate key in the configmap,
which you can then load like so:

```bash
./generate-automations.sh
```

---
This repo is templated via
[homelab-template](https://github.com/charlesthomas/homelab-template)
and automatically updated via
[🤖 Templatron](https://github.com/charlesthomas/templatron).
