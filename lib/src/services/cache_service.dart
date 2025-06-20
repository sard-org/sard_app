import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const Duration _defaultCacheExpiry = Duration(minutes: 15);
  
  // Singleton pattern
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Cache keys
  static const String _booksKey = 'cached_books';
  static const String _favoritesKey = 'cached_favorites';
  static const String _booksTimestampKey = 'books_timestamp';
  static const String _favoritesTimestampKey = 'favorites_timestamp';

  // Generic cache methods
  Future<void> _setCacheData(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(data);
      await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving cache data: $e');
    }
  }

  Future<dynamic> _getCacheData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString);
      }
    } catch (e) {
      print('Error reading cache data: $e');
    }
    return null;
  }

  Future<void> _setTimestamp(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error saving timestamp: $e');
    }
  }

  Future<DateTime?> _getTimestamp(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(key);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      print('Error reading timestamp: $e');
    }
    return null;
  }

  bool _isCacheValid(DateTime? timestamp, Duration expiry) {
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < expiry;
  }

  // Books cache methods
  Future<void> cacheBooks(List<dynamic> books) async {
    await _setCacheData(_booksKey, books);
    await _setTimestamp(_booksTimestampKey);
  }

  Future<List<dynamic>?> getCachedBooks({Duration? expiry}) async {
    final timestamp = await _getTimestamp(_booksTimestampKey);
    final cacheExpiry = expiry ?? _defaultCacheExpiry;
    
    if (_isCacheValid(timestamp, cacheExpiry)) {
      final data = await _getCacheData(_booksKey);
      if (data is List) {
        return data;
      }
    }
    return null;
  }

  Future<void> clearBooksCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_booksKey);
    await prefs.remove(_booksTimestampKey);
  }

  // Favorites cache methods
  Future<void> cacheFavorites(List<dynamic> favorites) async {
    await _setCacheData(_favoritesKey, favorites);
    await _setTimestamp(_favoritesTimestampKey);
  }

  Future<List<dynamic>?> getCachedFavorites({Duration? expiry}) async {
    final timestamp = await _getTimestamp(_favoritesTimestampKey);
    final cacheExpiry = expiry ?? _defaultCacheExpiry;
    
    if (_isCacheValid(timestamp, cacheExpiry)) {
      final data = await _getCacheData(_favoritesKey);
      if (data is List) {
        return data;
      }
    }
    return null;
  }

  Future<void> clearFavoritesCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
    await prefs.remove(_favoritesTimestampKey);
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    await clearBooksCache();
    await clearFavoritesCache();
  }

  // Check if cache exists for a specific type
  Future<bool> hasCachedBooks() async {
    return await getCachedBooks() != null;
  }

  Future<bool> hasCachedFavorites() async {
    return await getCachedFavorites() != null;
  }
} 