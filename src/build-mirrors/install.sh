#!/bin/bash
set -e

MAVEN_MIRROR_URL="${MAVENMIRRORURL:-http://maven-mirror:8080/central}"
MAVEN_MIRROR_ID="${MAVENMIRRORID:-dockerized-mirror}"
NPM_TOKEN="${NPMTOKEN:-dummy-token}"

mkdir -p /usr/local/lib/devcontainer-features

cat > /usr/local/lib/devcontainer-features/build-mirrors-setup.sh <<OUTER
#!/bin/bash
set -e

# Maven mirror — write settings.xml into the (potentially volume-mounted) .m2 dir
M2_DIR="\${HOME}/.m2"
mkdir -p "\$M2_DIR"
cat > "\$M2_DIR/settings.xml" <<EOF
<settings>
    <mirrors>
        <mirror>
            <id>${MAVEN_MIRROR_ID}</id>
            <name>Local Mirror Repository</name>
            <url>${MAVEN_MIRROR_URL}</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
</settings>
EOF
echo "[build-mirrors] Maven mirror configured: ${MAVEN_MIRROR_URL}"

# npm mirror — requires \$NPM_MIRROR env var (set via remoteEnv in devcontainer.json)
if [ -n "\${NPM_MIRROR}" ]; then
  npm config set "//\${NPM_MIRROR}/:_authToken" "${NPM_TOKEN}"
  echo "[build-mirrors] npm auth token set for \${NPM_MIRROR}"
else
  echo "[build-mirrors] NPM_MIRROR not set — skipping npm mirror config."
fi
OUTER

chmod +x /usr/local/lib/devcontainer-features/build-mirrors-setup.sh
