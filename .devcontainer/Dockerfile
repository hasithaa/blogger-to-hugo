# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.191.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ARG BALLERINA_DEB_URL=""

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
RUN wget ${BALLERINA_DEB_URL} -O /tmp/ballerina-linux-installer.deb \ 
    && dpkg -i /tmp/ballerina-linux-installer.deb \
    && rm /tmp/ballerina-linux-installer.deb \
    && ln -s /usr/lib/ballerina/dependencies/jdk-11.0.8+10-jre/bin/java /usr/bin/java
