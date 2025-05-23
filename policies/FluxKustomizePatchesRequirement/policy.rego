package policy

import future.keywords.in

default exclude_namespaces := []
default exclude_label_key := ""
default exclude_label_value := ""

exclude_namespaces := input.parameters.exclude_namespaces
exclude_label_key := input.parameters.exclude_label_key
exclude_label_value := input.parameters.exclude_label_value
patches_required := input.parameters.patches_required

violation[result] {
    isExcludedNamespace == false
    not exclude_label_value == controller_input.metadata.labels[exclude_label_key]
    hasPatches := object_has_patches(controller_spec)
    hasPatches != patches_required
    msg := get_message(patches_required)
    result = {
        "issue_detected": true,
        "msg": msg,
        "violating_key": "spec.patches"
    }
}

object_has_patches(spec) {
    count(spec.patches) > 0
} else = false

get_message(true) = "The 'spec.patches' field in a Kustomization object must have values based on the policy input"

get_message(false) = "The 'spec.patches' field in a Kustomization object must be empty based on the policy input"

# Controller input
controller_input = input.review.object

# controller_spec acts as an iterator to get spec from the Kustomization object
controller_spec = controller_input.spec {
    controller_input.kind == "Kustomization"
}

isExcludedNamespace = true {
    controller_input.metadata.namespace
    controller_input.metadata.namespace in exclude_namespaces
} else = false
