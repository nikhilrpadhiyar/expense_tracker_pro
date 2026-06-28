import 'package:hive_flutter/hive_flutter.dart';

/// Thin typed wrapper around Hive boxes.
class HiveStorage {
  const HiveStorage();

  Box<T> box<T>(String name) => Hive.box<T>(name);

  Future<void> put<T>(String boxName, String key, T value) =>
      Hive.box<T>(boxName).put(key, value);

  T? get<T>(String boxName, String key) =>
      Hive.box<T>(boxName).get(key);

  List<T> getAll<T>(String boxName) =>
      Hive.box<T>(boxName).values.toList();

  Future<void> delete<T>(String boxName, String key) =>
      Hive.box<T>(boxName).delete(key);

  Future<void> clear<T>(String boxName) =>
      Hive.box<T>(boxName).clear();
}
