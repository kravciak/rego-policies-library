# RabbitMQ Enforce Environment Variable - RABBITMQ_LOG_BASE

This Policy ensures RABBITMQ_LOG_BASE environment variable are in place when using the official container images from Docker Hub.
RABBITMQ_LOG_BASE: This base directory contains the RabbitMQ server's log files, unless RABBITMQ_LOGS is set.


If you encounter a violation, ensure the RABBITMQ_LOG_BASE environment variables is set.
For futher information about the RabbitMQ Docker container, check here: https://hub.docker.com/_/rabbitmq


# Settings
```yaml
  settings:
    parameters:
      - name: exclude_namespaces
        type: array
        required: false
        value:
      - name: exclude_label_key
        type: string
        required: false
        value:
      - name: exclude_label_value
        type: string
        required: false
        value:
```

# Resources
Policy applies to resources kinds:
`Deployment`, `Job`, `ReplicationController`, `ReplicaSet`, `DaemonSet`, `StatefulSet`, `CronJob`
