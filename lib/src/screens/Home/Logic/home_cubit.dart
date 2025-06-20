import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../Data/home_model.dart';
import '../Data/home_dio.dart';
import 'home_state.dart';
import '../../../utils/error_translator.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  // Cache variables
  UserModelhome? _cachedUserData;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 10); // User data cache expires after 10 minutes

  // Check if cache is valid
  bool get _isCacheValid {
    return _cachedUserData != null && 
           _lastFetchTime != null && 
           DateTime.now().difference(_lastFetchTime!) < _cacheExpiry;
  }

  Future<void> getUserData({bool forceRefresh = false}) async {
    try {
      // If cache is valid and not forced refresh, use cached data
      if (_isCacheValid && !forceRefresh) {
        developer.log('📱 CACHE: Using cached user data - ${_cachedUserData!.name}');
        developer.log('📱 CACHE: Last fetch time: $_lastFetchTime');
        developer.log('📱 CACHE: Cache age: ${DateTime.now().difference(_lastFetchTime!).inMinutes} minutes');
        emit(HomeLoaded(_cachedUserData!));
        return;
      }

      developer.log('🌐 API: Fetching user data from server - ${forceRefresh ? "Force refresh" : "Cache expired or empty"}');
      emit(HomeLoading());
      
      final response = await HomeDio.dio.get('users/me/home');

      final data = response.data;
      developer.log('API Response: $data', name: 'HomeCubit');

      if (data is Map<String, dynamic>) {
        try {
          final userModel = UserModelhome.fromJson(data);
          
          // Update cache
          _cachedUserData = userModel;
          _lastFetchTime = DateTime.now();
          
          developer.log('💾 CACHE: Updated user data cache for ${userModel.name} at $_lastFetchTime');
          
          emit(HomeLoaded(userModel));
        } catch (e) {
          developer.log('Error parsing UserModel: $e', name: 'HomeCubit');
          emit(HomeError('خطأ في تحليل البيانات: $e'));
        }
      } else {
        developer.log('Unexpected data format: ${data.runtimeType}', name: 'HomeCubit');
        emit(HomeError('نوع البيانات غير متوقع'));
      }
    } catch (e) {
      developer.log('❌ ERROR: Failed to fetch user data - $e');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(HomeError(userFriendlyError));
    }
  }

  // Method to refresh data (pull to refresh)
  Future<void> refreshUserData() async {
    developer.log('🔄 REFRESH: Force refreshing user data');
    await getUserData(forceRefresh: true);
  }

  // Clear cache when needed
  void clearCache() {
    developer.log('🗑️ CACHE: Clearing user data cache');
    _cachedUserData = null;
    _lastFetchTime = null;
  }

  // Get cache status for debugging
  Map<String, dynamic> getCacheStatus() {
    return {
      'hasCachedData': _cachedUserData != null,
      'userName': _cachedUserData?.name,
      'userPoints': _cachedUserData?.points,
      'userStreak': _cachedUserData?.streak,
      'lastFetchTime': _lastFetchTime?.toString(),
      'isValid': _isCacheValid,
      'ageInMinutes': _lastFetchTime != null 
        ? DateTime.now().difference(_lastFetchTime!).inMinutes 
        : null,
    };
  }
}
