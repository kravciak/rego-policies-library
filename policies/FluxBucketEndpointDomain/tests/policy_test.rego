package policy

import data.policy.violation

test_valid_endpoint_domain {
  testcase = {
    "parameters": {
      "exclude_namespaces": [],
      "exclude_label_key": "",
      "exclude_label_value": "",
      "domains": ["example.com", "trusted.com"]
    },
    "review": {
      "object": {
        "apiVersion": "v1",
        "kind": "Bucket",
        "metadata": {
          "name": "valid-bucket",
        },
        "spec": {
          "endpoint": "example.com"
        }
      }
    }
  }

  count(violation) == 0 with input as testcase
}

test_invalid_endpoint_domain {
  testcase = {
    "parameters": {
      "exclude_namespaces": [],
      "exclude_label_key": "",
      "exclude_label_value": "",
      "domains": ["example.com", "trusted.com"]
    },
    "review": {
      "object": {
        "apiVersion": "v1",
        "kind": "Bucket",
        "metadata": {
          "name": "invalid-bucket",
        },
        "spec": {
          "endpoint": "minio.untrusted.com"
        }
      }
    }
  }

  count(violation) == 1 with input as testcase
}

test_exclude_label_endpoint_domain {
  testcase = {
    "parameters": {
      "exclude_namespaces": [],
      "exclude_label_key": "exclude",
      "exclude_label_value": "true",
      "domains": ["example.com", "trusted.com"]
    },
    "review": {
      "object": {
        "apiVersion": "v1",
        "kind": "Bucket",
        "metadata": {
          "name": "invalid-bucket",
          "labels": {
            "exclude": "true"
          }
        },
        "spec": {
          "endpoint": "minio.untrusted.com"
        }
      }
    }
  }

  count(violation) == 0 with input as testcase
}

test_exclude_namespace_endpoint_domain {
  testcase = {
    "parameters": {
      "exclude_namespaces": ["excluded-namespace"],
      "exclude_label_key": "",
      "exclude_label_value": "",
      "domains": ["example.com", "trusted.com"]
    },
    "review": {
      "object": {
        "apiVersion": "v1",
        "kind": "Bucket",
        "metadata": {
          "name": "invalid-bucket",
          "namespace": "excluded-namespace",
        },
        "spec": {
          "endpoint": "minio.untrusted.com"
        }
      }
    }
  }

  count(violation) == 0 with input as testcase
}
