import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;

import '../Data/categories_dio.dart';
import '../Data/categories_model.dart';
import 'categories_state.dart';
import '../../../../utils/error_translator.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesService _categoriesService;

  CategoriesCubit(this._categoriesService) : super(CategoriesInitial());

  // Cache variables for categories - Fixed type to match CategoriesLoaded
  List<Category>? _cachedCategories;
  DateTime? _lastCategoriesFetchTime;
  static const Duration _categoriesCacheExpiry = Duration(minutes: 30); // Categories don't change often
  
  // Cache variables for category books
  Map<String, List<dynamic>> _cachedCategoryBooks = {};
  Map<String, DateTime> _categoryBooksLastFetchTime = {};
  static const Duration _categoryBooksCacheExpiry = Duration(minutes: 15);

  // Check if categories cache is valid
  bool get _isCategoriesCacheValid {
    return _cachedCategories != null && 
           _lastCategoriesFetchTime != null && 
           DateTime.now().difference(_lastCategoriesFetchTime!) < _categoriesCacheExpiry;
  }

  // Check if category books cache is valid
  bool _isCategoryBooksCacheValid(String categoryId) {
    return _cachedCategoryBooks.containsKey(categoryId) &&
           _categoryBooksLastFetchTime.containsKey(categoryId) &&
           DateTime.now().difference(_categoryBooksLastFetchTime[categoryId]!) < _categoryBooksCacheExpiry;
  }

  Future<void> getCategories({bool forceRefresh = false}) async {
    try {
      // If cache is valid and not forced refresh, use cached data
      if (_isCategoriesCacheValid && !forceRefresh) {
        dev.log('📱 CACHE: Using cached categories data - ${_cachedCategories!.length} categories');
        dev.log('📱 CACHE: Last fetch time: $_lastCategoriesFetchTime');
        dev.log('📱 CACHE: Cache age: ${DateTime.now().difference(_lastCategoriesFetchTime!).inMinutes} minutes');
        emit(CategoriesLoaded(_cachedCategories!)); // Fixed: Added ! to ensure non-null
        return;
      }

      dev.log('🌐 API: Fetching categories from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(CategoriesLoading());
      
      final categoriesResponse = await _categoriesService.getCategories();
      
      // Update cache - Fixed: Store the correct type
      _cachedCategories = categoriesResponse.categories;
      _lastCategoriesFetchTime = DateTime.now();
      
      dev.log('💾 CACHE: Updated categories cache with ${categoriesResponse.categories.length} items at $_lastCategoriesFetchTime');
      
      emit(CategoriesLoaded(categoriesResponse.categories));
    } catch (e) {
      dev.log('❌ ERROR: Failed to fetch categories - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(CategoriesError(userFriendlyError));
    }
  }

  // Method to refresh categories (pull to refresh)
  Future<void> refreshCategories() async {
    dev.log('🔄 REFRESH: Force refreshing categories data');
    await getCategories(forceRefresh: true);
  }

  Future<void> getCategoryBooks(String categoryId, {bool forceRefresh = false}) async {
    try {
      // If cache is valid and not forced refresh, use cached data
      if (_isCategoryBooksCacheValid(categoryId) && !forceRefresh) {
        dev.log('📱 CACHE: Using cached category books for $categoryId - ${_cachedCategoryBooks[categoryId]!.length} books');
        emit(CategoryBooksLoaded(_cachedCategoryBooks[categoryId]!));
        return;
      }

      dev.log('🌐 API: Fetching category books for $categoryId from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(CategoryBooksLoading());
      
      final books = await _categoriesService.getCategoryBooks(categoryId);
      
      // Update cache
      _cachedCategoryBooks[categoryId] = books;
      _categoryBooksLastFetchTime[categoryId] = DateTime.now();
      
      dev.log('💾 CACHE: Updated category books cache for $categoryId with ${books.length} items');
      
      emit(CategoryBooksLoaded(books));
    } catch (e) {
      dev.log('❌ ERROR: Failed to fetch category books for $categoryId - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(CategoriesError(userFriendlyError));
    }
  }

  // Method to refresh category books
  Future<void> refreshCategoryBooks(String categoryId) async {
    dev.log('🔄 REFRESH: Force refreshing category books for $categoryId');
    await getCategoryBooks(categoryId, forceRefresh: true);
  }

  // Clear cache when needed
  void clearCache() {
    dev.log('🗑️ CACHE: Clearing categories cache');
    _cachedCategories = null;
    _lastCategoriesFetchTime = null;
    _cachedCategoryBooks.clear();
    _categoryBooksLastFetchTime.clear();
  }

  // Clear category books cache for specific category
  void clearCategoryBooksCache(String categoryId) {
    dev.log('🗑️ CACHE: Clearing category books cache for $categoryId');
    _cachedCategoryBooks.remove(categoryId);
    _categoryBooksLastFetchTime.remove(categoryId);
  }

  // Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'hasCachedCategories': _cachedCategories != null,
      'categoriesCount': _cachedCategories?.length ?? 0,
      'lastCategoriesFetchTime': _lastCategoriesFetchTime?.toString(),
      'isCategoriesValid': _isCategoriesCacheValid,
      'categoriesAgeInMinutes': _lastCategoriesFetchTime != null 
        ? DateTime.now().difference(_lastCategoriesFetchTime!).inMinutes 
        : null,
      'cachedCategoryBooksCount': _cachedCategoryBooks.length,
      'categoryBooksCache': _cachedCategoryBooks.keys.toList(),
    };
  }
}
