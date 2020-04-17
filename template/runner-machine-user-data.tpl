# Create UserData script for the docker machine
cat <<EOF >> ${runner_user_data_filepath}
#!/usr/bin/env bash

# gitlab-runner spawned instances require passwordless sudo
echo "ec2-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

#ufw allow in on docker0
#ufw reload

# Test disabling firewall
ufw disable

## Avoid an OOM bug in Docker
## https://www.terraform.io/docs/enterprise/before-installing/rhel-requirements.html
yum-config-manager --enable rhel-7-server-rhui-extras-rpms
yum install docker -y

# Got error:
# ERROR: Preparation failed: Error response from daemon: shim error: docker-runc not installed on system
# Testing copying docker-runc-current to /usr/bin/docker-runc
cp /usr/libexec/docker/docker-runc-current /usr/bin/docker-runc

# Remove Deprecated option RhostsRSAAuthentication
sed -i '/RSAAuthentication/d' /etc/ssh/sshd_config
systemctl restart sshd
EOF

chmod 644 ${runner_user_data_filepath}
