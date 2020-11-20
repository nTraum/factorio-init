ARG ubuntu_version=20.04

### A base image without test resources:
FROM ubuntu:$ubuntu_version AS no-test-resources
ARG factorio_user=factorio
ARG factorio_group=factorio

RUN apt-get update && apt-get install -y \
    parallel \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN addgroup --system $factorio_group
RUN adduser --system --ingroup $factorio_group $factorio_user

USER $factorio_user
WORKDIR /opt/factorio-init
ENTRYPOINT ["bash", "/opt/factorio-init/test/libs/bats-core/bin/bats"]

### Build onto the base, add test resources:
FROM no-test-resources AS with-test-resources
ENV FACTORIO_INIT_WITH_TEST_RESOURCES=1
ARG factorio_version=1.0.0

RUN wget -O /tmp/factorio_headless_x64_${factorio_version}.tar.xz \
     https://factorio.com/get-download/${factorio_version}/headless/linux64
