import 'package:hive_ce/hive.dart';

import 'i_cache_service.dart';

class HiveCacheService implements ICacheService {
  final String _boxName;

  HiveCacheService.onboarding() : _boxName = "onboarding";
  HiveCacheService.auth() : _boxName = "auth";
  HiveCacheService.profile() : _boxName = "profile";

  Box? _box;

  @override
  Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  @override
  Future<void> put<T>(String key, T value) async {
    await init();
    await _box?.put(key, value);
  }

  @override
  Future<T?> get<T>(String key) async{
    await init();
    final value = _box?.get(key);
    if (value is T) return value;
    return null;
  }

  @override
  Future<void> remove(String key) async {
    await init();
    await _box?.delete(key);
  }

  @override
  Future<void> clear() async {
    await init();
    await _box?.clear();
  }
}
