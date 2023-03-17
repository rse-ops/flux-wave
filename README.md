# Flux Wave

Testing procuring a Flux container using [wave](https://wavecontainers.io/api/#request).
Specifically, we will build a container here with LAMMPS (without Flux) and then
use wave to add flux, and test that everything works.

## Preparing Layers

It looks like wave requires a direct URL to download from, so we can't just grab them
from the docker image. Here is how I prepared that:

```bash
# Pull the container
$ docker pull ghcr.io/rse-ops/flux-conda:mamba-layer-focal

# Find the right layer (should be on the top)
$ docker history ghcr.io/rse-ops/flux-conda:mamba-layer-focal

# Save the entire tar
$ docker save ghcr.io/rse-ops/flux-conda:mamba-layer-focal -o layers.tar
```

Then find the layer you want (from the hash you saw in docker history)

```bash
tar tvf layers.tar
```
```console
drwxr-xr-x 0/0               0 2023-03-16 16:10 5568ce6883bde966e1d141dd1f1dacd80b9510c6e2b6944efbca605e5430c018/
-rw-r--r-- 0/0               3 2023-03-16 16:10 5568ce6883bde966e1d141dd1f1dacd80b9510c6e2b6944efbca605e5430c018/VERSION
-rw-r--r-- 0/0            6978 2023-03-16 16:10 5568ce6883bde966e1d141dd1f1dacd80b9510c6e2b6944efbca605e5430c018/json
-rw-r--r-- 0/0      2968244736 2023-03-16 16:10 5568ce6883bde966e1d141dd1f1dacd80b9510c6e2b6944efbca605e5430c018/layer.tar  <-- this one
```

And then extract it

```bash
$ tar xf layers.tar 5568ce6883bde966e1d141dd1f1dacd80b9510c6e2b6944efbca605e5430c018/layer.tar
```

And then turn into targz

```bash
$ cd 5568ce6883bde966e1d141dd1f1dacd80b9510c6e2b6944efbca605e5430c018
$ gzip -9 < layer.tar > flux-focal-layer.tar.gz
```
I then uploaded it to a release file - next steps TBA.
