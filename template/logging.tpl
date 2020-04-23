# Create CloudWatch Logs config for GitLab
cat <<EOF >> /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/gitlab.json
{
  "logs": {
    "log_stream_name": "{instance_id}",
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/dmesg",
            "log_group_name": "{hostname}",
            "log_stream_name": "{instance_id}/dmesg"
          },
          {
            "file_path": "/var/log/user-data.log",
            "log_group_name": "{hostname}",
            "log_stream_name": "{instance_id}/user-data"
          }
        ]
      }
    }
  }
}
EOF

# Append the GitLab CW Logs config to our existing configuration
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a append-config -m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/gitlab.json -s
