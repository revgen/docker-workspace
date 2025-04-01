#!/ur/bin/env bash
set -e
read -p "The script is installing Docker. Continue (y/N)? " opt
[ "${opt}" != "y" ] && echo "Skip" && exit 1

apt -y install docker.io && \
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose && \
echo "Done"
