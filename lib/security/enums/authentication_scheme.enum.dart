enum AuthenticationScheme {
  /// The server doesn't requires a client credential, and provides a temporary identity to the node.
  /// Some restriction may apply to guest sessions,  like the inability of sending some commands or other nodes may want to block messages originated by guest identities.
  guest,

  /// Username and password authentication.
  plain,

  /// Transport layer authentication.
  transport,

  /// Key authentication.
  key,

  /// Third-party authentication.
  external
}
