NAMESPACE=idos
APP=nginx-php-fpm
TAG=latest

build-all:
	docker build --no-cache=true -t ${NAMESPACE}/${APP}:${TAG} .

build:
	docker build -t ${NAMESPACE}/${APP}:${TAG} .

stop:
	docker stop ${APP}

clean:
	docker stop ${APP} && docker rm ${APP}

reset: clean
	docker rmi ${NAMESPACE}/${APP}:${TAG}

remove:
	docker rm ${APP}
