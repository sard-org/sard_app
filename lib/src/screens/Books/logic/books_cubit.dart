import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/Books/data/dio_client.dart';
import 'package:sard/src/screens/Books/book_model.dart';
import 'books_state.dart';
import '../../../utils/error_translator.dart';
import 'dart:developer' as dev;

class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksInitial());

  // Cache variables
  List<Book>? _cachedBooks;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 15); // Cache expires after 15 minutes

  // Check if cache is valid
  bool get _isCacheValid {
    return _cachedBooks != null && 
           _lastFetchTime != null && 
           DateTime.now().difference(_lastFetchTime!) < _cacheExpiry;
  }

  Future<void> fetchBooks({bool forceRefresh = false}) async {
    try {
      // If cache is valid and not forced refresh, use cached data
      if (_isCacheValid && !forceRefresh) {
        dev.log('📱 CACHE: Using cached books data - ${_cachedBooks!.length} books');
        dev.log('📱 CACHE: Last fetch time: $_lastFetchTime');
        dev.log('📱 CACHE: Cache age: ${DateTime.now().difference(_lastFetchTime!).inMinutes} minutes');
        emit(BooksLoaded(_cachedBooks!));
        return;
      }

      dev.log('🌐 API: Fetching books from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(BooksLoading());

      // استخدام endpoint للطلبات حيث تخزن معلومات الكتب
      final response = await DioClient.dio.get('/orders/');

      if (response.statusCode == 200) {
        // تحقق من نوع البيانات وتعامل معها بشكل مناسب
        dynamic responseData = response.data;
        List<dynamic> booksJson = [];

        if (responseData is Map<String, dynamic> && responseData['data'] is List) {
          booksJson = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          booksJson = responseData;
        }

        final books = booksJson
            .where((json) => json is Map<String, dynamic> && json['book'] != null)
            .map((json) {
              final book = Book.fromJson(json['book'] as Map<String, dynamic>);
              final orderId = json['id']?.toString() ?? '';
              return book.copyWith(orderId: orderId);
            })
            .toList();

        // Update cache
        _cachedBooks = books;
        _lastFetchTime = DateTime.now();
        
        dev.log('💾 CACHE: Updated cache with ${books.length} books at $_lastFetchTime');
        
        emit(BooksLoaded(books));
      } else {
        emit(const BooksError('فشل تحميل الكتب'));
      }
    } catch (e) {
      dev.log('❌ ERROR: Failed to fetch books - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(BooksError(userFriendlyError));
    }
  }

  // Method to refresh data (pull to refresh)
  Future<void> refreshBooks() async {
    dev.log('🔄 REFRESH: Force refreshing books data');
    await fetchBooks(forceRefresh: true);
  }

  // Clear cache when needed
  void clearCache() {
    dev.log('🗑️ CACHE: Clearing books cache');
    _cachedBooks = null;
    _lastFetchTime = null;
  }

  // Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'hasCachedData': _cachedBooks != null,
      'cacheSize': _cachedBooks?.length ?? 0,
      'lastFetchTime': _lastFetchTime?.toString(),
      'isValid': _isCacheValid,
      'ageInMinutes': _lastFetchTime != null 
        ? DateTime.now().difference(_lastFetchTime!).inMinutes 
        : null,
    };
  }
}