import 'package:lime/protocol/enums/session_compression.enum.dart';
import 'package:lime/protocol/enums/session_encryption.enum.dart';
import 'package:lime/protocol/envelope.dart';

import 'envelope_listener.dart';

abstract class Transport extends EnvelopeListener {
  Future<void> open();
  Future<void> close();

  Future<void> send(Envelope envelope);

  SessionCompression? compression;

  SessionEncryption? encryption;
}
