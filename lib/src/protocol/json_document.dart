import 'document.dart';
import 'media_type.dart';
import 'types/discrete_types.dart';
import 'types/sub_types.dart';

class JsonDocument extends Document implements Map<String, Object> {
  final Map<String, Object> json;

  JsonDocument({required this.json, MediaType? mediaType})
      : super(mediaType: mediaType ?? MediaType(type: DiscreteTypes.application, subtype: SubTypes.json)) {
    if (!this.mediaType.isJson()) {
      throw ArgumentError.value("The media type is not a valid json type");
    }
  }

  void setMediaType(MediaType mediaType) {
    if (!mediaType.isJson()) {
      throw ArgumentError.value("The media type is not a valid json type");
    }

    this.mediaType = mediaType;
  }

  @override
  String toString() => json.toString();

  @override
  void addAll(Map<String, Object> other) {
    json.addAll(other);
  }

  @override
  void addEntries(Iterable<MapEntry<String, Object>> newEntries) {
    json.addEntries(newEntries);
  }

  @override
  Map<RK, RV> cast<RK, RV>() => json.cast<RK, RV>();

  @override
  void clear() {
    json.clear();
  }

  @override
  bool containsKey(Object? key) => json.containsKey(key);

  @override
  bool containsValue(Object? value) => json.containsValue(value);

  @override
  void forEach(void Function(String key, Object value) action) {
    json.forEach(action);
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(String key, Object value) convert) => json.map<K2, V2>(convert);

  @override
  putIfAbsent(String key, Object Function() ifAbsent) => json.putIfAbsent(key, ifAbsent);

  @override
  remove(Object? key) => json.remove(key);

  @override
  void removeWhere(bool Function(String key, Object value) test) => json.removeWhere(test);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  update(String key, Object Function(Object value) update, {Object Function()? ifAbsent}) =>
      json.update(key, update, ifAbsent: ifAbsent);

  @override
  void updateAll(Object Function(String key, Object value) update) {
    updateAll(update);
  }
}
