#!/bin/sh
set -eu

IMAGES="
codimd
mysql
volumio
"

DOCKER_TAG="${DOCKER_TAG:-master}"

# Build images.
for image in $IMAGES; do
	echo "Building ldh0227/$image"
	docker build "$image" --tag "ldh0227/$image:$DOCKER_TAG" --build-arg DOCKER_TAG="$DOCKER_TAG"
	docker tag "ldh0227/$image:$DOCKER_TAG" "ldh0227/$image:latest"
done

echo "Build success"

if [ "${CI:-}" != "true" ]; then
	echo "Not in CI environment, stopping here"
	exit 0
fi

# Push images, with the new tag.
for image in $IMAGES; do
	echo "Pushing ldh0227/$image:$DOCKER_TAG"
	docker push "ldh0227/$image:$DOCKER_TAG"
done

# Update latest tag.
for image in $IMAGES; do
	echo "Pushing ldh0227/$image:latest"
	docker push "ldh0227/$image:latest"
done

echo "Done"
