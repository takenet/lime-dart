import '../enums/command_status.enum.dart';
import '../reason.dart';

class LimeException extends Error {
  final CommandStatus status;
  final Reason reason;
  final bool timeout;

  LimeException(this.status, int code, {String? description, this.timeout = false})
      : reason = Reason(code: code, description: description);

  @override
  String toString() {
    return reason.toString();
  }
}
