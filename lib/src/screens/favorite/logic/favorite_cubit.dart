import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/dio_Fav.dart';
import 'favorite_state.dart';
import '../../../utils/error_translator.dart';
import 'dart:developer' as dev;

class FavoriteCubit extends Cubit<FavoriteState> {
  final DioFav dioFav;
  final String token;

  FavoriteCubit({required this.dioFav, required this.token}) : super(FavoriteInitial());

  // Cache variables
  List<dynamic>? _cachedFavorites;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 15); // Cache expires after 15 minutes

  // Check if cache is valid
  bool get _isCacheValid {
    return _cachedFavorites != null && 
           _lastFetchTime != null && 
           DateTime.now().difference(_lastFetchTime!) < _cacheExpiry;
  }

  Future<void> getFavorites({bool forceRefresh = false}) async {
    try {
      // If cache is valid and not forced refresh, use cached data
      if (_isCacheValid && !forceRefresh) {
        dev.log('📱 CACHE: Using cached favorites data - ${_cachedFavorites!.length} items');
        dev.log('📱 CACHE: Last fetch time: $_lastFetchTime');
        dev.log('📱 CACHE: Cache age: ${DateTime.now().difference(_lastFetchTime!).inMinutes} minutes');
        emit(FavoriteSuccessState(_cachedFavorites!));
        return;
      }

      dev.log('🌐 API: Fetching favorites from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(FavoriteLoadingState());
      final data = await dioFav.getFavorites(token);
      
      // Update cache
      _cachedFavorites = data;
      _lastFetchTime = DateTime.now();
      
      dev.log('💾 CACHE: Updated favorites cache with ${data.length} items at $_lastFetchTime');
      
      emit(FavoriteSuccessState(data));
    } catch (e) {
      dev.log('❌ ERROR: Failed to fetch favorites - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(FavoriteErrorState(userFriendlyError));
    }
  }

  // Method to refresh data (pull to refresh)
  Future<void> refreshFavorites() async {
    dev.log('🔄 REFRESH: Force refreshing favorites data');
    await getFavorites(forceRefresh: true);
  }

  Future<void> addFavorite(String id) async {
    try {
      dev.log('➕ FAVORITES: Adding item $id to favorites');
      await dioFav.addToFavorite(token, id);
      // Force refresh after adding to get updated list
      await getFavorites(forceRefresh: true);
    } catch (e) {
      dev.log('❌ ERROR: Failed to add favorite - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(FavoriteErrorState(userFriendlyError));
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      dev.log('➖ FAVORITES: Removing item $id from favorites');
      await dioFav.removeFromFavorite(token, id);
      // Force refresh after removing to get updated list
      await getFavorites(forceRefresh: true);
    } catch (e) {
      dev.log('❌ ERROR: Failed to remove favorite - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(FavoriteErrorState(userFriendlyError));
    }
  }

  // Clear cache when needed
  void clearCache() {
    dev.log('🗑️ CACHE: Clearing favorites cache');
    _cachedFavorites = null;
    _lastFetchTime = null;
  }

  // Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'hasCachedData': _cachedFavorites != null,
      'cacheSize': _cachedFavorites?.length ?? 0,
      'lastFetchTime': _lastFetchTime?.toString(),
      'isValid': _isCacheValid,
      'ageInMinutes': _lastFetchTime != null 
        ? DateTime.now().difference(_lastFetchTime!).inMinutes 
        : null,
    };
  }
}
