#!/bin/sh

# change sshd_config
if [ -f "/etc/ssh/sshd_config" ]; then
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
fi

# prepare run dir
if [ ! -d "/var/run/sshd" ]; then
    mkdir -p /var/run/sshd
fi

# prepare root ssh folder
if [ ! -d "/root/.ssh/" ]; then
    mkdir -p /root/.ssh/ && chmod 700 /root/.ssh/
fi

# prepare authorized_keys
if [ -d "/sshkey/" ]; then
    cp /sshkey/* /root/.ssh/ && chown root:root /root/.ssh/*
fi

exec "$@"
