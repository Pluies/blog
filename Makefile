PORT=9001
BASEURL=http://localhost:$(PORT)/

build:
	docker build .

dev:
	docker build . \
		--file=Dockerfile.dev \
		--build-arg BASEURL=$(BASEURL) \
		--tag blog:dev
	@echo "\nStarting blog at $(BASEURL)\n"
	docker run -it -p $(PORT):80 blog:dev
