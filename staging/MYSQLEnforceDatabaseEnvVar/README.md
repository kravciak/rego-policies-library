# MYSQL Enforce Environment Variable - MYSQL_DATABASE

This Policy ensures MYSQL_DATABASE environment variable are in place when using the official container images from Docker Hub.
MYSQL_DATABASE: The MYSQL_DATABASE environment variable sets a default MySQL database instance up with the name of that DB being the value of  environment variable. 


If you encounter a violation, ensure the MYSQL_DATABASE environment variables is set.
For futher information about the MYSQL Docker container, check here: https://hub.docker.com/_/mysql


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
