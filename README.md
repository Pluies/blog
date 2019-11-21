# blog

Source for [https://blog.florentdelannoy.com/](https://blog.florentdelannoy.com/)

## Run locally

- Checkout this repository
- Initialise the submodules: `git submodule update --init`
- Run: `hugo serve`

## Build

- `docker build .`

Do it once the content has changed to ensure everything works 👌

## Deploy

`git push` triggers a builds on the [the Docker Hub](https://hub.docker.com/r/pluies/blog/builds)

Actual deployment on Kubernetes: TBD.
