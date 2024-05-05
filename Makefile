HERE := ${CURDIR}

CONTAINER := playground-python

build:
	docker build -t ${CONTAINER} .devcontainer

run:
	docker run  -v ${HERE}/workspace:/workspace -it ${CONTAINER}
