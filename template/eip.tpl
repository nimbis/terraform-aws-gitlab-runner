echo 'installing additional software for assigning EIP'

curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
export PATH=~/.local/bin:$PATH

pip install aws-ec2-assign-elastic-ip awscli
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
/bin/aws-ec2-assign-elastic-ip --valid-ips ${eip}
