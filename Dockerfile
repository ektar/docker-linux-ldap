from ektar/linux-base:v1.0.4
MAINTAINER eric@ds-do.com

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && apt install -qy \
    auth-client-config \
    gosu \
    ldap-utils \
    libldap2-dev \
    libnss-sss \
    libpam-sss \
    libsasl2-dev \
    libssl-dev \
    man \
    python-ldap \
    python-pip \
    sssd \
    sssd-tools \
    sudo \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install ssh-ldap-pubkey

RUN echo "AuthorizedKeysCommand /usr/local/bin/ssh-ldap-pubkey-wrapper\\nAuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config

RUN echo "%admins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# If password auth is to be allowed, uncomment this line
#RUN sed -i.bak 's/^#\(PasswordAuthentication yes\)/\1/' /etc/ssh/sshd_config

RUN mkdir /data

COPY startup.sh /data/startup.sh

COPY VERSION /ver-linux-ldap

ENTRYPOINT ["/data/startup.sh"]

EXPOSE 22
