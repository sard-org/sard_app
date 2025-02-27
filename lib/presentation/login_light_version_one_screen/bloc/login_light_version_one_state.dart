part of 'login_light_version_one_bloc.dart';

/// Represents the state of LoginLightVersionOne in the application.

// ignore_for_file: must_be_immutable
class LoginLightVersionOneState extends Equatable {
  LoginLightVersionOneState(
      {this.searchController,
      this.loginLightVersionOneInitialModelObj,
      this.loginLightVersionOneModelObj});

  TextEditingController? searchController;

  LoginLightVersionOneModel? loginLightVersionOneModelObj;

  LoginLightVersionOneInitialModel? loginLightVersionOneInitialModelObj;

  @override
  List<Object?> get props => [
        searchController,
        loginLightVersionOneInitialModelObj,
        loginLightVersionOneModelObj
      ];
  LoginLightVersionOneState copyWith({
    TextEditingController? searchController,
    LoginLightVersionOneInitialModel? loginLightVersionOneInitialModelObj,
    LoginLightVersionOneModel? loginLightVersionOneModelObj,
  }) {
    return LoginLightVersionOneState(
      searchController: searchController ?? this.searchController,
      loginLightVersionOneInitialModelObj:
          loginLightVersionOneInitialModelObj ??
              this.loginLightVersionOneInitialModelObj,
      loginLightVersionOneModelObj:
          loginLightVersionOneModelObj ?? this.loginLightVersionOneModelObj,
    );
  }
}

