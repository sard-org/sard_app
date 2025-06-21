import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchCacheService {
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 10;

  // Get search history from cache
  static Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_searchHistoryKey);
      
      if (historyJson != null) {
        final historyList = json.decode(historyJson) as List;
        return historyList.cast<String>();
      }
      
      return [];
    } catch (e) {
      print('Error getting search history: $e');
      return [];
    }
  }

  // Add search query to history
  static Future<void> addSearchToHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = await getSearchHistory();
      
      // Remove if already exists to avoid duplicates
      history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
      
      // Add to the beginning
      history.insert(0, query.trim());
      
      // Keep only the most recent items
      if (history.length > _maxHistoryItems) {
        history = history.take(_maxHistoryItems).toList();
      }
      
      // Save to preferences
      await prefs.setString(_searchHistoryKey, json.encode(history));
    } catch (e) {
      print('Error adding search to history: $e');
    }
  }

  // Clear search history
  static Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchHistoryKey);
    } catch (e) {
      print('Error clearing search history: $e');
    }
  }

  // Remove specific search from history
  static Future<void> removeSearchFromHistory(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = await getSearchHistory();
      
      history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
      
      await prefs.setString(_searchHistoryKey, json.encode(history));
    } catch (e) {
      print('Error removing search from history: $e');
    }
  }
} 