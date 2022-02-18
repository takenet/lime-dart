import 'types/discrete_types.dart';
import 'types/sub_types.dart';

class MediaType {
  /// Represents the text/plain media type.
  static final MediaType textPlain =
      MediaType(type: DiscreteTypes.text, subtype: SubTypes.plain);

  /// Represents the application/json media type.
  static final MediaType applicationJson =
      MediaType(type: DiscreteTypes.application, subtype: SubTypes.json);

  /// Initializes a new instance of the MediaType class.
  MediaType({required this.type, required this.subtype, this.suffix});

  /// The top-level type identifier. The valid values are text, application, image, audio and video.
  final String type;

  /// The media type subtype.
  final String subtype;

  /// Media type suffix
  final String? suffix;

  /// Indicates if the MIME represents a JSON type.
  bool isJson() =>
      suffix?.toLowerCase() == SubTypes.json ||
      subtype.toLowerCase() == SubTypes.json;

  @override
  String toString() =>
      '$type/$subtype${(suffix?.isNotEmpty ?? false) ? '+$suffix' : ''}';

  /// Returns a hash code for this instance.
  @override
  int get hashCode => toString().hashCode;

  /// Implements the operator ==
  @override
  bool operator ==(other) => _equals(other);

  factory MediaType.fromString(String? value) => parse(value);

  /// Parses the string to a MediaType object.
  static MediaType parse(String? s) {
    if (s?.isEmpty ?? true) {
      throw ArgumentError.notNull('value');
    }

    final splittedMediaType = s?.split(';')[0].split('/');
    if (splittedMediaType?.length != 2) {
      throw const FormatException("Invalid media type format");
    }

    final type = splittedMediaType?[0] ?? '';
    final splittedSubtype = splittedMediaType?[1].split('+');
    final subtype = splittedSubtype?[0] ?? '';
    String? suffix;

    if ((splittedSubtype?.length ?? 0) > 1) {
      suffix = splittedSubtype?[1];
    }

    return MediaType(type: type, subtype: subtype, suffix: suffix);
  }

  /// Try parses the string to a MediaType object.
  static bool tryParse(
    String s,
  ) {
    try {
      parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Determines whether the specified <see cref="System.Object" />, is equal to this instance.
  bool _equals(other) {
    final mediaType = other as MediaType?;

    if (mediaType == null) return false;

    return type.toLowerCase() == mediaType.type.toLowerCase() &&
        subtype.toLowerCase() == mediaType.subtype.toLowerCase() &&
        suffix?.toLowerCase() == mediaType.suffix?.toLowerCase();
  }
}
