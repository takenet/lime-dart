/// Defines the envelope routing rules.
enum RoutingRule {
  instance,
  identity,

  @Deprecated(
      "Use 'promiscuous' property from presence with 'identity' routing rule")
  promiscuous,

  domain,
  rootDomain,
}
