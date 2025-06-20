import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;
import '../Withoutcategories/data/recommendations_api_service.dart';
import '../Withoutcategories/data/exchange_books_api_service.dart';
import '../Withoutcategories/data/recommendations_model.dart';
import '../Withoutcategories/data/exchange_books_model.dart';
import 'home_books_state.dart';
import '../../../utils/error_translator.dart';

class HomeBooksLCubit extends Cubit<HomeBooksState> {
  final RecommendationsApiService _recommendationsService;
  final ExchangeBooksApiService _exchangeBooksService;

  HomeBooksLCubit({
    required RecommendationsApiService recommendationsService,
    required ExchangeBooksApiService exchangeBooksService,
  })  : _recommendationsService = recommendationsService,
        _exchangeBooksService = exchangeBooksService,
        super(HomeBooksInitial()) {
    dev.log('🎯 HomeBooksLCubit created successfully');
  }

  // Cache variables for recommended books
  List<RecommendedBook>? _cachedRecommendedBooks;
  DateTime? _lastRecommendedBooksFetchTime;
  static const Duration _recommendedBooksCacheExpiry = Duration(minutes: 20);

  // Cache variables for exchange books
  List<ExchangeBook>? _cachedExchangeBooks;
  DateTime? _lastExchangeBooksFetchTime;
  static const Duration _exchangeBooksCacheExpiry = Duration(minutes: 20);

  // Check if recommended books cache is valid
  bool get _isRecommendedBooksCacheValid {
    return _cachedRecommendedBooks != null &&
           _lastRecommendedBooksFetchTime != null &&
           DateTime.now().difference(_lastRecommendedBooksFetchTime!) < _recommendedBooksCacheExpiry;
  }

  // Check if exchange books cache is valid
  bool get _isExchangeBooksCacheValid {
    return _cachedExchangeBooks != null &&
           _lastExchangeBooksFetchTime != null &&
           DateTime.now().difference(_lastExchangeBooksFetchTime!) < _exchangeBooksCacheExpiry;
  }

  Future<void> loadRecommendedBooks({bool forceRefresh = false, int? limit}) async {
    try {
      dev.log('🔍 DEBUG: loadRecommendedBooks called - forceRefresh: $forceRefresh, limit: $limit');
      dev.log('🔍 DEBUG: Cache validity: ${_isRecommendedBooksCacheValid}');
      dev.log('🔍 DEBUG: Cached books count: ${_cachedRecommendedBooks?.length ?? 0}');
      
      // If cache is valid and not forced refresh, use cached data
      if (_isRecommendedBooksCacheValid && !forceRefresh) {
        dev.log('📱 CACHE: Using cached recommended books - ${_cachedRecommendedBooks!.length} books');
        dev.log('📱 CACHE: Last fetch time: $_lastRecommendedBooksFetchTime');
        dev.log('📱 CACHE: Cache age: ${DateTime.now().difference(_lastRecommendedBooksFetchTime!).inMinutes} minutes');
        
        final booksToShow = limit != null 
          ? _cachedRecommendedBooks!.take(limit).toList()
          : _cachedRecommendedBooks!;
        
        emit(RecommendedBooksLoaded(booksToShow));
        return;
      }

      dev.log('🌐 API: Fetching recommended books from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(RecommendedBooksLoading());

      final books = await _recommendationsService.getRecommendations();
      
      // Update cache
      _cachedRecommendedBooks = books;
      _lastRecommendedBooksFetchTime = DateTime.now();
      
      dev.log('💾 CACHE: Updated recommended books cache with ${books.length} items at $_lastRecommendedBooksFetchTime');
      
      final booksToShow = limit != null 
        ? books.take(limit).toList()
        : books;
      
      emit(RecommendedBooksLoaded(booksToShow));
    } catch (e) {
      dev.log('❌ ERROR: Failed to fetch recommended books - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(RecommendedBooksError(userFriendlyError));
    }
  }

  Future<void> loadExchangeBooks({bool forceRefresh = false, int? limit}) async {
    try {
      dev.log('🔍 DEBUG: loadExchangeBooks called - forceRefresh: $forceRefresh, limit: $limit');
      dev.log('🔍 DEBUG: Cache validity: ${_isExchangeBooksCacheValid}');
      dev.log('🔍 DEBUG: Cached books count: ${_cachedExchangeBooks?.length ?? 0}');
      
      // If cache is valid and not forced refresh, use cached data
      if (_isExchangeBooksCacheValid && !forceRefresh) {
        dev.log('📱 CACHE: Using cached exchange books - ${_cachedExchangeBooks!.length} books');
        dev.log('📱 CACHE: Last fetch time: $_lastExchangeBooksFetchTime');
        dev.log('📱 CACHE: Cache age: ${DateTime.now().difference(_lastExchangeBooksFetchTime!).inMinutes} minutes');
        
        final booksToShow = limit != null 
          ? _cachedExchangeBooks!.take(limit).toList()
          : _cachedExchangeBooks!;
        
        emit(ExchangeBooksLoaded(booksToShow));
        return;
      }

      dev.log('🌐 API: Fetching exchange books from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(ExchangeBooksLoading());

      final books = await _exchangeBooksService.getExchangeBooks();
      
      // Update cache
      _cachedExchangeBooks = books;
      _lastExchangeBooksFetchTime = DateTime.now();
      
      dev.log('💾 CACHE: Updated exchange books cache with ${books.length} items at $_lastExchangeBooksFetchTime');
      
      final booksToShow = limit != null 
        ? books.take(limit).toList()
        : books;
      
      emit(ExchangeBooksLoaded(booksToShow));
    } catch (e) {
      dev.log('❌ ERROR: Failed to fetch exchange books - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(ExchangeBooksError(userFriendlyError));
    }
  }

  Future<void> loadAllHomeBooks({bool forceRefresh = false}) async {
    try {
      emit(HomeBooksLoading());
      
      await Future.wait([
        loadRecommendedBooks(forceRefresh: forceRefresh, limit: 4),
        loadExchangeBooks(forceRefresh: forceRefresh, limit: 3),
      ]);
      
      emit(HomeBooksAllLoaded());
    } catch (e) {
      dev.log('❌ ERROR: Failed to load all home books - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(HomeBooksError(userFriendlyError));
    }
  }

  // Method to refresh all data (pull to refresh)
  Future<void> refreshAllHomeBooks() async {
    dev.log('🔄 REFRESH: Force refreshing all home books');
    await loadAllHomeBooks(forceRefresh: true);
  }

  Future<void> refreshRecommendedBooks() async {
    dev.log('🔄 REFRESH: Force refreshing recommended books');
    await loadRecommendedBooks(forceRefresh: true, limit: 4);
  }

  Future<void> refreshExchangeBooks() async {
    dev.log('🔄 REFRESH: Force refreshing exchange books');
    await loadExchangeBooks(forceRefresh: true, limit: 3);
  }

  // Clear cache when needed
  void clearCache() {
    dev.log('🗑️ CACHE: Clearing all home books cache');
    _cachedRecommendedBooks = null;
    _lastRecommendedBooksFetchTime = null;
    _cachedExchangeBooks = null;
    _lastExchangeBooksFetchTime = null;
  }

  void clearRecommendedBooksCache() {
    dev.log('🗑️ CACHE: Clearing recommended books cache');
    _cachedRecommendedBooks = null;
    _lastRecommendedBooksFetchTime = null;
  }

  void clearExchangeBooksCache() {
    dev.log('🗑️ CACHE: Clearing exchange books cache');
    _cachedExchangeBooks = null;
    _lastExchangeBooksFetchTime = null;
  }

  // Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'recommendedBooks': {
        'hasCachedData': _cachedRecommendedBooks != null,
        'count': _cachedRecommendedBooks?.length ?? 0,
        'lastFetchTime': _lastRecommendedBooksFetchTime?.toString(),
        'isValid': _isRecommendedBooksCacheValid,
        'ageInMinutes': _lastRecommendedBooksFetchTime != null 
          ? DateTime.now().difference(_lastRecommendedBooksFetchTime!).inMinutes 
          : null,
      },
      'exchangeBooks': {
        'hasCachedData': _cachedExchangeBooks != null,
        'count': _cachedExchangeBooks?.length ?? 0,
        'lastFetchTime': _lastExchangeBooksFetchTime?.toString(),
        'isValid': _isExchangeBooksCacheValid,
        'ageInMinutes': _lastExchangeBooksFetchTime != null 
          ? DateTime.now().difference(_lastExchangeBooksFetchTime!).inMinutes 
          : null,
      },
    };
  }
} 