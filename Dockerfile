ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}

ARG UID=1000

# Update and add ansible user
RUN set -xe \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y gosu zsh curl git python python-pip \
    && pip install molecule docker \
    && useradd -m -s /bin/zsh ansible \
    && gosu ansible curl -s -L --output /home/ansible/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc \
    && gosu ansible curl -s -L --output /home/ansible/.zshrc.local https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc

# Install the newest version of ansible
RUN set -xe \
    && gosu ansible mkdir /home/ansible/src \
    && apt-get -y install software-properties-common \
    && apt-add-repository --yes --update ppa:ansible/ansible \
    && apt-get -y install ansible

WORKDIR /home/ansible/src

COPY ./docker-entrypoint.sh /entrypoint
ENTRYPOINT [ "/entrypoint" ]
