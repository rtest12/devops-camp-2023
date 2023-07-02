IMAGE_NAME := oom:v1
CONTAINER_NAME := oom_v1
DEFAULT_LIMIT := 100m

build:
	docker build -t $(IMAGE_NAME) .

run:
	@if [ -z "$(limit)" ]; then \
		docker run --rm --name $(CONTAINER_NAME) -m $(DEFAULT_LIMIT) $(IMAGE_NAME); \
	else \
		docker run --name $(CONTAINER_NAME) -m $(limit) $(IMAGE_NAME) || (docker inspect $(CONTAINER_NAME) --format='{{.State}}' && exit 1); \
	fi

.PHONY: build run
