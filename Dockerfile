from ektar/linux-base:v1.0.1
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
	python-ldap \
	python-pip \
    sssd \
    sssd-tools \
	sudo \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install ssh-ldap-pubkey

RUN echo "AuthorizedKeysCommand /usr/local/bin/ssh-ldap-pubkey-wrapper\\nAuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config

# If password auth is to be allowed, uncomment this line
#RUN sed -i.bak 's/^#\(PasswordAuthentication yes\)/\1/' /etc/ssh/sshd_config

# COPY profile.d-sss /etc/auth-client-config/profile.d/sss

# COPY ldap.conf /etc/ldap.conf

# COPY sssd.conf /etc/sssd/sssd.conf

# RUN chown -R root:root /etc/sssd && chmod 600 /etc/sssd/sssd.conf

RUN mkdir /data

COPY startup.sh /data/startup.sh

ENTRYPOINT ["/data/startup.sh"]

EXPOSE 22
