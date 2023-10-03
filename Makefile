export GO111MODULE := on

now := $(shell date -u +%Y-%m-%dT%H:%M:%S%z)
gitBranch := $(shell git rev-parse --abbrev-ref HEAD)
gitCommit := $(shell git rev-parse --short HEAD)


ver ?= 0.13.0
drepo ?= memphisos
linkerVars := -X main.BuildTime=$(now) -X main.GitInfo=$(gitBranch)-$(gitCommit) -X main.Version=$(ver)



memphis-config-reloader.docker:
	CGO_ENABLED=0 GOOS=linux go build -o $@ \
		-ldflags "-s -w $(linkerVars)" \
		-tags timetzdata \
		./

.PHONY: memphis-config-reloader-docker
memphis-config-reloader-docker:
ifneq ($(ver),)
	docker build --tag $(drepo)/memphis-config-reloader-test:$(ver) \
		--build-arg VERSION=$(ver)
else
	# Missing version, try this.
	# make memphis-config-reloader-docker ver=1.2.3
	exit 1
endif

.PHONY: memphis-config-reloader-dockerx
memphis-config-reloader-dockerx:
ifneq ($(ver),)
	# Ensure 'docker buildx ls' shows correct platforms.
	docker buildx build \
		--tag $(drepo)/memphis-config-reloader-test:$(ver) \
		--build-arg VERSION=$(ver) \
		--platform linux/amd64,linux/arm64 \
		--push .
else
	# Missing version, try this.
	# make memphis-config-reloader-dockerx ver=1.2.3
	exit 1
endif

