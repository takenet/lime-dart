import 'dart:core';
import 'package:lime/extensions/string.extension.dart';
import 'package:lime/protocol/identity.dart';

class LimeUri {
  static const String limeUriScheme = 'lime';

  Uri? _absoluteUri;

  /// Initializes a new instance of the LimeUri class.
  LimeUri({String? uriPath}) {
    final uri = uriPath ?? '';

    if (uri.isEmpty) throw ArgumentError.notNull('uriPath');

    if (Uri.tryParse(uri)?.isAbsolute ?? false) {
      _absoluteUri = Uri.parse(uri);
      _validatLimeScheme(_absoluteUri);
    } else {
      throw ArgumentError('Invalid URI format');
    }

    path = uri.trimEnd('/');
  }

  /// URI path.
  String? path;

  /// Indicates if the path is relative.
  bool get isRelative => _absoluteUri == null;

  /// Convert the relative path to a Uri, using the identity as the URI authority.
  Uri? toUri({Identity? authority}) {
    if (authority == null) {
      if (_absoluteUri == null) {
        throw Exception('The URI path is relative');
      }

      return _absoluteUri;
    } else {
      if (_absoluteUri != null) {
        throw Exception('The URI path is absolute');
      }

      final baseUri = getBaseUri(authority);

      return Uri.parse('${baseUri.toString().trimEnd('/')}/$path');
    }
  }

  /// Returns a hash code for this instance.
  @override
  int get hashCode => toString().toLowerCase().hashCode;

  /// Determines whether the specified Object, is equal to this instance.
  @override
  bool operator ==(other) {
    final limeUri = other as LimeUri?;
    return limeUri != null &&
        path?.toLowerCase() == limeUri.path?.toLowerCase();
  }

  /// Returns a String that represents this instance.
  @override
  String toString() => path ?? '';

  /// Parses the specified value.
  static LimeUri parse(String? value) {
    return LimeUri(uriPath: value);
  }

  static Uri getBaseUri(Identity authority) {
    return Uri.parse('$limeUriScheme://$authority/');
  }

  static LimeUri? fromString(String? value) =>
      value == null ? null : parse(value);

  void _validatLimeScheme(Uri? absoluteUri) {
    if (absoluteUri?.scheme != limeUriScheme) {
      throw ArgumentError('Invalid URI scheme. Expected is \'$limeUriScheme\'');
    }
  }
}
