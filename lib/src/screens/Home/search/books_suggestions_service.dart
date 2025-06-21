import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class BooksSuggestionsService {
  static const String baseUrl = 'https://api.mohamed-ramadan.me/api';
  final Dio _dio = Dio();

  Future<List<String>> getRandomBookTitles({int count = 8}) async {
    try {
      print('Fetching books from: $baseUrl/books/');
      
      // Get auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      
      if (token.isEmpty) {
        print('No auth token found, using fallback suggestions');
        return _getFallbackSuggestions();
      }
      
      // Add authorization header
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      final response = await _dio.get('$baseUrl/books/', options: options);
      
      if (response.statusCode == 200) {
        final data = response.data;
        print('API Response structure: ${data.runtimeType}');
        print('API Response keys: ${data is Map ? data.keys : 'Not a Map'}');
        
        // Try different possible structures
        List<dynamic> books = [];
        
        if (data is List) {
          // If response is directly a list
          books = data;
          print('Response is a direct list with ${books.length} items');
        } else if (data is Map) {
          // If response is wrapped in an object
          books = data['data'] ?? data['books'] ?? data['results'] ?? [];
          print('Response is a map, extracted ${books.length} books');
        }
        
        if (books.isNotEmpty) {
          print('First book structure: ${books.first}');
        }
        
        // Extract book titles
        List<String> titles = books
            .map((book) {
              String title = '';
              if (book is Map) {
                title = book['title']?.toString() ?? 
                       book['name']?.toString() ?? 
                       book['book_title']?.toString() ?? '';
              }
              return title;
            })
            .where((title) => title.isNotEmpty)
            .toList();
        
        print('Extracted ${titles.length} valid titles');
        if (titles.isNotEmpty) {
          print('Sample titles: ${titles.take(3).join(", ")}');
        }
        
        // Shuffle and take random titles
        if (titles.length > count) {
          titles.shuffle(Random());
          titles = titles.take(count).toList();
        }
        
        return titles.isNotEmpty ? titles : _getFallbackSuggestions();
      } else {
        print('Failed to fetch books: ${response.statusCode}');
        return _getFallbackSuggestions();
      }
    } catch (e) {
      print('Error fetching book suggestions: $e');
      return _getFallbackSuggestions();
    }
  }

  // Fallback suggestions in case API fails
  List<String> _getFallbackSuggestions() {
    return [
      'الإسلام',
      'لسان آدم',
      'فكر تصبح غنيًا',
      'علم النفس',
      'الفلسفة',
      'الروايات العربية',
      'كتب الأطفال',
      'الثقافة العامة',
      'السيرة النبوية',
      'الأصدقاء',
    ].take(8).toList();
  }
} 