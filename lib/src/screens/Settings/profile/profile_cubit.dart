import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_api_service.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileApiService _profileApiService;

  ProfileCubit(this._profileApiService) : super(ProfileInitial());

  // Get user profile
  Future<void> getUserProfile() async {
    try {
      emit(ProfileLoading());
      final user = await _profileApiService.getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      emit(ProfileUpdateLoading());
      final updatedUser = await _profileApiService.updateUserProfile(userData);
      emit(ProfileUpdateSuccess(updatedUser));
      // Refresh profile data after successful update
      await getUserProfile();
    } catch (e) {
      emit(ProfileUpdateError(e.toString()));
    }
  }

  // Initialize profile service with token
  static Future<ProfileCubit> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('No auth token found');
    }
    final profileService = ProfileApiService.init(token);
    return ProfileCubit(profileService);
  }
} 