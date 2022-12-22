import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';

class LoggerService {
  LoggerService() {
    logger.setLevel(
      Level.INFO,
      includeCallerInfo: true,
    );
  }

  final logger = SimpleLogger();

  String? info(Object? message) {
    if (kDebugMode) {
      return logger.info(message);
    }

    return null;
  }

  String? shout(Object? message) {
    if (kDebugMode) {
      return logger.shout(message);
    }

    return null;
  }

  String? warning(Object? message) {
    if (kDebugMode) {
      return logger.warning(message);
    }

    return null;
  }
}
