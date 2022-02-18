import '../enums/session_compression.enum.dart';
import '../enums/session_encryption.enum.dart';
import '../envelope.dart';

import 'envelope_listener.dart';

abstract class Transport extends EnvelopeListener {
  Future<void> open();
  Future<void> close();

  Future<void> send(Envelope envelope);

  SessionCompression? compression;

  SessionEncryption? encryption;
}
