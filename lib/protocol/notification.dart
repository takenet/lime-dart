import 'package:lime/protocol/enums/event.enum.dart';
import 'package:lime/protocol/envelope.dart';
import 'package:lime/protocol/reason.dart';

class Notification extends Envelope {
  static const String eventKey = "event";
  static const String reasonKey = "reason";

  Notification({String? id}) : super(id: id);

  /// Related event to the notification
  Event? event;

  /// In the case of a failed event, brings more details about the problem.
  Reason? reason;
}
