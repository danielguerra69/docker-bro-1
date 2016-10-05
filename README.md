# alpine-bro-build

Builds bro from git for alpine linux
Used for building
danielguerra/alpine-bro-elasticsearch

## Instructions
```
docker run --rm -ti -v $(pwd):/final danielguerra/alpine-bro-build
docker build --rm -t my-bro .
docker run mybro
```
