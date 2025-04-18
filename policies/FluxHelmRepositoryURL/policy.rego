package policy

import future.keywords.in

default exclude_namespaces := []
default exclude_label_key := ""
default exclude_label_value := ""

domains := input.parameters.domains
exclude_namespaces := input.parameters.exclude_namespaces
exclude_label_key := input.parameters.exclude_label_key
exclude_label_value := input.parameters.exclude_label_value

violation[result] {
    isExcludedNamespace == false
    not exclude_label_value == controller_input.metadata.labels[exclude_label_key]
    repository_url := controller_spec.url
    not domain_matches(repository_url, domains)
    result = {
        "issue_detected": true,
        "msg": sprintf("The HelmRepository URL must be from one of the allowed domains '%s'; found '%s'", [domains, repository_url]),
        "violating_key": "spec.url"
    }
}

domain_matches(url, domains) {
    is_http_or_https(url)
    parts := split(url, "/")
    count(parts) > 2
    domain := parts[2]
    valid_domain(domain, domains)
} else {
    is_oci(url)
    parts := split(trim(url, "oci://"), "/")
    domain := parts[0]
    valid_domain(domain, domains)
}

is_http_or_https(url) {
    startswith(url, "https://")
} else {
    startswith(url, "http://")
}

is_oci(url) {
    startswith(url, "oci://")
}

valid_domain(domain, domains) {
    some d
    domain == domains[d]
} else {
    some d
    concat_domain := concat(".", ["www", domains[d]])
    endswith(domain, concat_domain)
}

# Controller input
controller_input = input.review.object

# controller_container acts as an iterator to get containers from the template
controller_spec = controller_input.spec {
  controller_input.kind == "HelmRepository"
}

isExcludedNamespace = true {
  controller_input.metadata.namespace
  controller_input.metadata.namespace in exclude_namespaces
} else = false
