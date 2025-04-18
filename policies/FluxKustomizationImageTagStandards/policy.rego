package policy

import future.keywords.in

default exclude_namespaces := []
default exclude_label_key := ""
default exclude_label_value := ""

exclude_namespaces := input.parameters.exclude_namespaces
exclude_label_key := input.parameters.exclude_label_key
exclude_label_value := input.parameters.exclude_label_value

violation[result] {
    isExcludedNamespace == false
    not exclude_label_value == controller_input.metadata.labels[exclude_label_key]
    image := controller_spec.images[_]
    not valid_image_tag(image.newTag)
    result = {
        "issue_detected": true,
        "msg": sprintf("The Kustomization '%s' spec.images entry for image '%s' must comply with image tag/semver reference standards. Invalid tag: '%s'", [controller_input.metadata.name, image.name, image.newTag]),
        "violating_key": "spec.images"
    }
}

valid_image_tag(tag) {
    is_null(tag)
} else {
    semver.is_valid(tag)
}

controller_input = input.review.object

controller_spec = controller_input.spec {
  controller_input.kind == "Kustomization"
}

contains_kind(kind, kinds) {
  kinds[_] = kind
}

isExcludedNamespace = true {
  controller_input.metadata.namespace
  controller_input.metadata.namespace in exclude_namespaces
} else = false
