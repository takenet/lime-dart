import 'dart:typed_data';

import 'package:lime/tcp/json_buffer_read_result.dart';

class JsonBuffer {
  int jsonStartPos = 0;
  int jsonCurPos = 0;
  int jsonStackedBrackets = 0;
  bool jsonStarted = false;
  bool insideQuotes = false;
  bool isEscaping = false;
  late Uint8List buffer;
  int bufferCurPos = 0;

  JsonBuffer(int bufferSize) {
    buffer = Uint8List(bufferSize);
  }

  void increaseBufferCurPos(int bytes) {
    bufferCurPos += bytes;
  }

  JsonBufferReadResult tryExtractJsonFromBuffer() {
    if (bufferCurPos > buffer.length) {
      throw ArgumentError("Buffer current pos or length value is invalid", 'buffer');
    }

    Uint8List? json;

    int jsonLength = 0;
    for (int i = jsonCurPos; i < bufferCurPos; i++) {
      jsonCurPos = i + 1;

      /// ASCII 34 = '"'
      if (buffer[i] == 34 && !isEscaping) {
        insideQuotes = !insideQuotes;
      }

      if (!insideQuotes) {
        /// ASCII 123 = '{'
        if (buffer[i] == 123) {
          jsonStackedBrackets++;
          if (!jsonStarted) {
            jsonStartPos = i;
            jsonStarted = true;
          }

          /// ASCII 125 = '}'
        } else if (buffer[i] == 125) {
          jsonStackedBrackets--;
        }

        if (jsonStarted && jsonStackedBrackets == 0) {
          jsonLength = i - jsonStartPos + 1;
          break;
        }
      } else {
        if (isEscaping) {
          isEscaping = false;
        }

        /// ASCII 92 = '\'
        else if (buffer[i] == 92) {
          isEscaping = true;
        }
      }
    }

    if (jsonLength > 1) {
      json = Uint8List(jsonLength);
      json.setRange(0, jsonLength, buffer, jsonStartPos);
      // System.arraycopy(buffer, jsonStartPos, json, 0, jsonLength);

      // Shifts the buffer to the left
      bufferCurPos -= (jsonLength + jsonStartPos);
      buffer.setRange(0, bufferCurPos, buffer, jsonLength + jsonStartPos);
      // System.arraycopy(buffer, jsonLength + jsonStartPos, buffer, 0, bufferCurPos);
      jsonCurPos = 0;
      jsonStartPos = 0;
      jsonStarted = false;
      insideQuotes = false;
      isEscaping = false;

      return JsonBufferReadResult(success: true, jsonBytes: json);
    }

    return JsonBufferReadResult(success: false);
  }
}
