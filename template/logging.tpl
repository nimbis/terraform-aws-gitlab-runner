# Create CloudWatch Logs config for GitLab
cat <<EOF >> /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/gitlab.conf
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/dmesg",
            "log_group_name": "${log_group_name}",
            "log_stream_name": "{instanceId}/dmesg"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "${log_group_name}",
            "timestamp_format": "%b %d %H:%M:%S",
            "log_stream_name": "{instanceId}/messages"
          },
          {
            "file_path": "/var/log/user-data.log",
            "log_group_name": "${log_group_name}",
            "log_stream_name": "{instanceId}/user-data"
          }
        ]
      }
    }
  }
}
EOF

# Replace instance id.
instanceId=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .instanceId)
sed -i -e "s/{instanceId}/$instanceId/g" /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/gitlab.conf

# Load GitLab CW Logs config
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config -m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/gitlab.json -s
