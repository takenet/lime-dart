import 'package:flutter/material.dart';
import 'package:lime/network/transport.dart';
import 'package:lime/protocol/envelope.dart';
import 'package:lime/protocol/enums/session_encryption.enum.dart';
import 'package:lime/protocol/enums/session_compression.enum.dart';

abstract class TransportBase implements Transport {
  SessionCompression compression;
  SessionEncryption encryption;
  TransportEnvelopeListener? transportEnvelopeListener;
  TransportStateListener? transportStateListener;
  bool? closingInvoked;
  bool? closedInvoked;

  TransportBase({
    this.compression = SessionCompression.none,
    this.encryption = SessionEncryption.none,
  });

  @override
  SessionCompression getCompression() {
    return compression;
  }

  @override
  SessionEncryption getEncryption() {
    return encryption;
  }

  @override
  List<SessionCompression> getSupportedCompression() {
    List<SessionCompression> list = [getCompression()];
    return list;
  }

  @override
  List<SessionEncryption> getSupportedEncryption() {
    List<SessionEncryption> list = [getEncryption()];
    return list;
  }

  void close() {
    if (!closingInvoked!) {
      raiseOnClosing();
      closingInvoked = true;
    }
    performClose();
    if (!closedInvoked!) {
      raiseOnClosed();
      closedInvoked = true;
    }
  }

  @override
  void open(Uri uri) {
    performOpen(uri);
    closingInvoked = false;
    closedInvoked = false;
  }

  @override
  void setCompression(SessionCompression compression) {
    if (!getSupportedCompression().contains(compression)) {
      throw ArgumentError('compression');
    }
    this.compression = compression;
  }

  @override
  void setEncryption(SessionEncryption encryption) {
    if (!getSupportedEncryption().contains(encryption)) {
      throw ArgumentError('encryption');
    }
    this.encryption = encryption;
  }

  @override
  void setEnvelopeListener(TransportEnvelopeListener listener) {
    transportEnvelopeListener = listener;
  }

  @override
  void setStateListener(TransportStateListener listener) {
    transportStateListener = listener;
  }

  @protected
  void performClose();

  @protected
  void performOpen(Uri uri);

  @protected
  TransportEnvelopeListener? getEnvelopeListener() {
    return transportEnvelopeListener;
  }

  @protected
  TransportStateListener? getStateListener() {
    return transportStateListener;
  }

  @protected
  void raiseOnReceive(Envelope envelope) {
    TransportEnvelopeListener? listener = getEnvelopeListener();
    if (listener != null) {
      listener.onReceive(envelope);
    } else {
      print(
          "An envelope was received while there's no listener registered - Id:${envelope.id}");
    }
  }

  @protected
  void raiseOnException(Exception e) {
    TransportStateListener? listener = getStateListener();
    if (listener != null) {
      listener.onException(e);
    } else {
      print(
          "An transport exception was received while there's no listener registered: ${e.toString()}");
    }
  }

  @protected
  void raiseOnClosing() {
    TransportStateListener? listener = getStateListener();
    if (listener != null) {
      listener.onClosing();
    } else {
      print(
          "The transport is about to be closed while there's no listener registered");
    }
  }

  @protected
  void raiseOnClosed() {
    TransportStateListener? listener = getStateListener();
    if (listener != null) {
      listener.onClosed();
    } else {
      print("The transport was closed while there's no listener registered");
    }
  }
}
