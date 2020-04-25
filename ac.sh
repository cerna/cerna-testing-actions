IMAGE_SUFFIX_ARRAY="amd64_8 amd64_9 amd64_10 arm64_9 arm64_10 i386_8 i386_9 i386_10 armhf_8 armhf_9 armhf_10"
IMAGE_NAME_ROOT="machinekit-hal-debian-builder-v"
REPOSITORY="machinekit-hal"
INPUT_JSON_FILE="pretty.json"
test_array=(${IMAGE_SUFFIX_ARRAY})
MISSING=0
for i in ${test_array[@]}
do
  IMAGENAME="${IMAGE_NAME_ROOT}$i"
  IMAGESHA=$(jq -r --arg IMAGENAME "$IMAGENAME" '.data.repository.registryPackagesForQuery.nodes[] | select(.name == $IMAGENAME).version.sha256' ${INPUT_JSON_FILE})
  if [ -z "$IMAGESHA" ]; then
    printf "Docker image $IMAGENAME:latest does not exist in registry docker.pkg.github.com/$REPOSITORY\n"
    ((MISSING=MISSING+1))
  fi
done
if [ $MISSING -gt 0 ]; then
  printf "Registry is missing $MISSING Docker image(s)\n"
fi

BEFORE="90c365aa3dbce414cb2bceee894e7f9e6fc4dc21"
if ! git rev-parse -q --verify "$BEFORE^{commit}" > /dev/null; then
  printf "Commit $BEFORE does not exists, this is probably force push\n"
fi

DOCKER_REGISTRY_USER="secrets.DOCKER_REGISTRY_USER"
DOCKER_REGISTRY_PASSWORD="secrets.DOCKER_REGISTRY_PASSWORD"
DOCKER_REGISTRY_PREFIX="secrets.DOCKER_REGISTRY_PREFIX }}"
if [ -n "$DOCKER_REGISTRY_USER" -a -n "$DOCKER_REGISTRY_PASSWORD" -a -n "$DOCKER_REGISTRY_PREFIX" ]; then
  printf "Docker Registry data found in GitHub secret storage, will try to upload\n"
else
  printf "Docker Registry data not found in GitHub secret storage\n"
fi
