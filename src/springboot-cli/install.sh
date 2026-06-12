#!/bin/bash
set -e

VERSION="${VERSION:-3.4.4}"

curl -fsSL "https://repo.maven.apache.org/maven2/org/springframework/boot/spring-boot-cli/${VERSION}/spring-boot-cli-${VERSION}-bin.tar.gz" \
  | tar xz -C /opt
ln -sf "/opt/spring-${VERSION}/bin/spring" /usr/local/bin/spring

echo "Spring Boot CLI ${VERSION} installed."
