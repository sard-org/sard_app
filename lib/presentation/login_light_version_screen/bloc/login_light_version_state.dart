part of 'login_light_version_bloc.dart';

/// Represents the state of LoginLightVersion in the application.

// ignore_for_file: must_be_immutable
class LoginLightVersionState extends Equatable {
  LoginLightVersionState(
      {this.searchController,
      this.loginlightTabModelObj,
      this.loginLightVersionModelObj});

  TextEditingController? searchController;

  LoginLightVersionModel? loginLightVersionModelObj;

  LoginlightTabModel? loginlightTabModelObj;

  @override
  List<Object?> get props =>
      [searchController, loginlightTabModelObj, loginLightVersionModelObj];
  LoginLightVersionState copyWith({
    TextEditingController? searchController,
    LoginlightTabModel? loginlightTabModelObj,
    LoginLightVersionModel? loginLightVersionModelObj,
  }) {
    return LoginLightVersionState(
      searchController: searchController ?? this.searchController,
      loginlightTabModelObj:
          loginlightTabModelObj ?? this.loginlightTabModelObj,
      loginLightVersionModelObj:
          loginLightVersionModelObj ?? this.loginLightVersionModelObj,
    );
  }
}

