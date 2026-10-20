abstract class ICacheService {
  Future<void> init();

  Future<void> put<T>(String key, T value);
  Future<T?> get<T>(String key);
  Future<void> remove(String key);
  Future<void> clear();
}
