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
