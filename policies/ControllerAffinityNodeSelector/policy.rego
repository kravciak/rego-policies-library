package policy

import future.keywords.in

default exclude_namespaces := []
default exclude_label_key := ""
default exclude_label_value := ""

key := input.parameters.key
value := input.parameters.value
exclude_namespaces := input.parameters.exclude_namespaces
exclude_label_key := input.parameters.exclude_label_key
exclude_label_value := input.parameters.exclude_label_value

violation[result] {
  isExcludedNamespace == false
  not exclude_label_value == controller_input.metadata.labels[exclude_label_key]
  not controller_spec.nodeSelector[key]
  result = {
    "issue_detected": true,
    "msg": sprintf("Looking for key '%v'; found '%v'", [key, controller_spec.nodeSelector]),
    "violating_key": "spec.template.spec.nodeSelector",
    "recommended_value": value  
  }
}

violation[result] {
  isExcludedNamespace == false
  not exclude_label_value == controller_input.metadata.labels[exclude_label_key]
  selector_value := controller_spec.nodeSelector[key]
  not selector_value == value
  result = {
    "issue_detected": true,
    "msg": sprintf("Looking for key value pair '%v:%v'; found '%v'", [key, value, controller_spec.nodeSelector]),
    "recommended_value": value,
    "violating_key": "spec.template.spec.nodeSelector[key]"
  }
}

# Controller input
controller_input = input.review.object

# controller_container acts as an iterator to get containers from the template
controller_spec = controller_input.spec.template.spec {
  contains_kind(controller_input.kind, {"StatefulSet" , "DaemonSet", "Deployment", "Job"})
} else = controller_input.spec {
  controller_input.kind == "Pod"
} else = controller_input.spec.jobTemplate.spec.template.spec {
  controller_input.kind == "CronJob"
}

contains_kind(kind, kinds) {
  kinds[_] = kind
}

isExcludedNamespace = true {
	controller_input.metadata.namespace
	controller_input.metadata.namespace in exclude_namespaces
} else = false
