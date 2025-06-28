class MemoryCacheService {
  final Map<String, dynamic> _cache = <String, dynamic>{};

  T? get<T>(String key) {
    if (_cache.containsKey(key)) {
      return _cache[key] as T?;
    }
    return null;
  }

  void set<T>(String key, T value) {
    _cache[key] = value;
  }

  void invalidate(String key) {
    _cache.remove(key);
  }

  void clearAll() {
    _cache.clear();
  }
}
