echo 'installing additional software for assigning EIP'

curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
export PATH=~/.local/bin:$PATH

pip install aws-ec2-assign-elastic-ip
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
/bin/aws-ec2-assign-elastic-ip --valid-ips ${eip}

# The AWS CLI is a requirement of the GitLab backup and restore scripts
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install
rm /tmp/awscliv2.zip
rm -rf /tmp/aws

# Add a symlink for the AWS CLI to /usr/bin
ln -s /usr/local/bin/aws /usr/bin/aws
