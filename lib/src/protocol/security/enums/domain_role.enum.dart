enum DomainRole {
  /// The identity is unknown in the domain.
  unknown,

  /// The identity is a member of the domain.
  member,

  /// The identity is an authority of the domain.
  authority,

  /// The identity is an authority of the domain and its sub-domains.
  rootAuthority
}
