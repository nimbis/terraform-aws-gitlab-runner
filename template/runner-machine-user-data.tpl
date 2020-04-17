# Create UserData script for the docker machine
cat <<EOF >> ${runner_user_data_filepath}
#!/usr/bin/env bash

# gitlab-runner spawned instances require passwordless sudo
echo "ec2-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Open ports for docker
ufw allow 2376
ufw allow in on docker0
ufw reload

# Avoid an OOM bug in Docker
# https://www.terraform.io/docs/enterprise/before-installing/rhel-requirements.html
yum-config-manager --enable rhel-7-server-rhui-extras-rpms
yum -y install docker

# Symlink docker-runc-current executable to /usr/bin/docker-run
# This is needed to avoid "docker-runc not installed on system" error
ln -s /usr/libexec/docker/docker-runc-current /usr/bin/docker-runc

# Remove Deprecated option RhostsRSAAuthentication
sed -i '/RSAAuthentication/d' /etc/ssh/sshd_config
systemctl restart sshd
EOF

chmod 644 ${runner_user_data_filepath}
