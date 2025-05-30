# Network Block All Ingress Traffic To Namespace From CIDR Block

If you are using a CNI that allows for Network Policies, you can use this Policy to block all Egress traffic from a specified namespace to a CIDR block of IP addresses.

By default, if no policies exist in a namespace, then all ingress and egress traffic is allowed to and from pods in that namespace.

Validate your use case and check network policies for traffic blocking.

https://kubernetes.io/docs/concepts/services-networking/network-policies/

# Settings

```yaml
settings:
  namespace: "namespace"
  cidr: "cidr"
  exclude_label_key: "" # optional
  exclude_label_value: "" # optional
```

# Resources

Policy applies to resources kinds:
`NetworkPolicy`
