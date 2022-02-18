import '../enums/data_operation.enum.dart';

abstract class ITraceWriter {
  /// Writes the provided data into the tracing output.
  Future<void> trace(String data, DataOperation operation);

  /// Indicates if the tracer is enabled.
  bool? isEnabled;
}
