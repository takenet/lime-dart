import '../enums/command_status.enum.dart';
import '../reason.dart';

class LimeException extends Error {
  final CommandStatus status;
  final Reason reason;

  LimeException(this.status, int code, {String? description})
      : reason = Reason(code: code, description: description);

  @override
  String toString() {
    return reason.toString();
  }
}
