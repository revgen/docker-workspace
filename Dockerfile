#FROM ubuntu:22.04
FROM ursamajorlab/noble-python:3.12

ARG NAME="rev9en/workspace"
ARG VERSION="1.0.2"
ARG BUILD_DATE="2021-12-23"
ARG DEVUSER=dev

LABEL version="${VERSION}"
LABEL maintainer="Evgen Rusakov"
LABEL description="Docker image with developer environment: python, nodejs, java, golang, aws-cli, azure-cli, gcloud-cli, oci-cli"
LABEL url.docker="https://hub.docker.com/r/${NAME}"
LABEL url.source="https://github.com/revgen/docker-workspace"

ENV DEBIAN_FRONTEND=noninteractive
ENV IMAGE_NAME=${NAME}
ENV IMAGE_VERSION=${VERSION}
ENV BUILD_DATE=${BUILD_DATE}

ENV AWS_DEFAULT_PROFILE=default
ENV AWS_DEFAULT_REGION=us-east-1
ENV AWS_REGION=${AWS_DEFAULT_REGION}
ENV TZ=America/New_York

RUN apt update && \
    mkdir -p /home/${DEVUSER} && \
    \
    apt install -y tzdata && \
    \
    apt install -y sudo vim-tiny && \
    ln -sv /usr/bin/vim.tiny /usr/bin/vim && touch /root/.vimrc && \
    \
    apt install -y openssl git tig curl wget less tree unzip jq screen mc && \
    apt install -y figlet dialog lynx && \
    apt install -y telnet iputils-ping dnsutils && \
    apt install -y ncdu && \
    \
    echo "--[ Install Python ] ---------------------------------" && \
    # apt install -y python3.11 && \
    # ln -sv /usr/bin/python3.11 /usr/bin/python3 && \
    # ln -sv /usr/bin/python3 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py && \
    python3 /tmp/get-pip.py && \
    python3 -m pip install --upgrade pip setuptools && \
    python3 -m pip install virtualenv && \
    pip install requests python-dotenv && \
    pip install pytest ruff isort && \
    \
    echo "--[ Install Node.JS ] --------------------------------" && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt install -y nodejs && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | PROFILE="/home/${DEVUSER}/.bash_env" bash && \
    rm -rf /root/.nvm/test && \
    \
    echo "--[ Install Java ]------------------------------------" && \
    apt install -y openjdk-21-jdk && \
    apt install -y gradle && \
    \
    echo "--[ Install Apache Maven ]----------------------------" && \
    curl -o apache-maven-3.9.9-bin.tar.gz https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar -xvf apache-maven-3.9.9-bin.tar.gz && \
    cp -vr apache-maven-3.9.9 /opt && mv /opt/apache-maven-3.9.9 /opt/apache-maven && \
    rm -rf apache-maven-3.9.9* && \
    ln -sv /opt/apache-maven/bin/mvn /usr/local/bin/mvn && \
    \
    echo "--[ Install GoLang ]----------------------------------" && \
    apt install -y golang && \
    rm -rf /usr/share/go-*/test && \
    \
    \
    echo "--[ Install aws-cli ]---------------------------------" && \
    cd /opt && curl -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" && \
    unzip awscliv2.zip -x aws/dist/awscli/examples/* && ./aws/install && \
    rm -rf ./aws/ aws*.zip && \
    \
    echo "--[ Install azure-cli ]-------------------------------" && \
    # curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    pip install azure-cli && \
    \
    echo "--[ Install gcloud-cli ]------------------------------" && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt update -y && \
    apt install -y google-cloud-cli && \
    apt install -y kubectl && \
    rm -f /usr/lib/google-cloud-sdk/bin/kubectl.* && \
    \
    echo "--[ Install oci-cli ]---------------------------------" && \
    pip3 install wcwidth pytz circuitbreaker types-python-dateutil terminaltables six PyYAML && \
    pip3 install pycparser certifi python-dateutil arrow cffi cryptography && \
    # Will be installed automatically: click jmespath PyYAML pyOpenSSL prompt_toolkit
    pip3 install oci oci_cli && \
    \
    # echo "Remove duplicates..." && \
    # rm -rf /opt/az/lib/python3.12 && \
    # ln -vs /usr/local/lib/python3.12 /opt/az/lib/python3.12 && \
    # rm -rf /opt/az/bin/python3.12 && \
    # ln -vs /usr/local/bin/python3.12 /opt/az/bin/python3.12 && \
    # rm -rf /usr/lib/google-cloud-sdk/platform/bundledpythonunix/lib/python3.12 && \
    # ln -vs /usr/local/lib/python3.12 /usr/lib/google-cloud-sdk/platform/bundledpythonunix/lib/python3.12 ** \
    \
    echo "Cleanup..." && \
    rm -rf /usr/share/icons/* && \
    rm -rf /usr/share/doc/* && \
    rm -rf /usr/share/X11/* && \
    find / -type d -name __pycache__ -exec rm -rvf "{}" \; || true && \
    \
    rm -rf /root/.cache/* && \
    rm -rf /var/lib/apt/lists/* /var/lib/dpkg/* /tmp/*

COPY ./root-fs/ /

RUN useradd -d /home/${DEVUSER} -s /bin/bash -m ${DEVUSER} && \
    addgroup --gid 107 docker && \
    usermod -a -G sudo,docker ${DEVUSER} && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    echo "${DEVUSER}:${DEVUSER}123" | chpasswd && \
    mkdir -p /home/${DEVUSER}/Documents && \
    mkdir -p /home/${DEVUSER}/Downloads && \
    mkdir -p /home/${DEVUSER}/workspace && \
    mkdir -p /home/${DEVUSER}/.cache && \
    touch /home/${DEVUSER}/.vimrc && \
    chmod +x /home/${DEVUSER}/.local/bin/* && \
    chown ${DEVUSER}:${DEVUSER} -R /home/${DEVUSER} && \
    \
    echo "--[ Create welcome text ]-----------------------------" && \
    su dev /home/${DEVUSER}/.local/bin/welcome-banner && \
    \
    chown ${DEVUSER}:${DEVUSER} -R /home/${DEVUSER}

USER ${DEVUSER}
WORKDIR /home/${DEVUSER}/workspace

# We need a full interactive login shell inside this image
CMD ["bash", "--login"]
