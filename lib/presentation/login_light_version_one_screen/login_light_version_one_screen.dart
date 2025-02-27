import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'bloc/login_light_version_one_bloc.dart';
import 'login_light_version_one_initial_page.dart';
import 'models/login_light_version_one_model.dart';

// ignore_for_file: must_be_immutable

class LoginLightVersionOneScreen extends StatelessWidget {
  LoginLightVersionOneScreen({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginLightVersionOneBloc>(
      create: (context) => LoginLightVersionOneBloc(
        LoginLightVersionOneState(
          loginLightVersionOneModelObj: LoginLightVersionOneModel(),
        ),
      )..add(LoginLightVersionOneInitialEvent()),
      child: LoginLightVersionOneScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Navigator(
          key: navigatorKey,
          initialRoute: AppRoutes.loginLightVersionOneInitialPage,
          onGenerateRoute: (routeSetting) => PageRouteBuilder(
            pageBuilder: (ctx, ani, ani1) => 
                getCurrentPage(context, routeSetting.name!),
            transitionDuration: Duration(seconds: 0),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  /// Bottom Navigation Bar Widget
  Widget _buildBottomBar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {},
      ),
    );
  }
}

/// Handling page based on route
Widget getCurrentPage(BuildContext context, String currentRoute) {
  switch (currentRoute) {
    case AppRoutes.loginLightVersionOneInitialPage:
      return LoginLightVersionOneInitialPage.builder(context);
    default:
      return LoginLightVersionOneInitialPage.builder(context);
  }
}
