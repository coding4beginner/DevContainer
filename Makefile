HERE      := ${CURDIR}
CONTAINER := playground-python

MESSAGE   := "Changes"

build:
	docker build -t ${CONTAINER} .devcontainer

run:
	docker run  -v ${HERE}/workspace:/workspace -it ${CONTAINER}

add:
	git add .

commit:
	git commit -m ${MESSAGE}

push:
	git push