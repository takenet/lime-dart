import 'dart:async';

class EnvelopeListener {
  /// A [StreamController] to allow listening when a new envelope is received by the websocket
  StreamController<Map<String, dynamic>>? onEnvelope;
  
  /// A [StreamController] to allow listening when server close the connection
  StreamController<bool>? onConnectionDone;
}
