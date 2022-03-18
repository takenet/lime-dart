/// Defines methods for the manipulation of resources.
enum CommandMethod {
  /// Gets an existing value of the resource.
  get,

  /// Creates or updates the value of the resource.
  set,

  /// Deletes a value of the resource or the resource itself.
  delete,

  /// Subscribes to the resource, allowing the originator to be notified when the value of the resource changes in the destination.
  subscribe,

  /// Unsubscribes to the resource, signaling to the destination that the originator do not want to receive further notifications about the resource.
  unsubscribe,

  /// Notify the destination about a change in the resource value of the sender.
  /// If the resource value is absent, it represent that the resource in the specified URI was deleted in the originator.
  /// This method is one way and the destination  SHOULD NOT send a response for it.
  /// Because of that, a command envelope with this method MAY NOT have an id.
  observe,

  /// Merges the resource document with an existing one. If the resource doesn't exists, it is created.
  merge,
}
