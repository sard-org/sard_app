import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../add_date_of_birth_light_version_dialog/add_date_of_birth_light_version_dialog.dart';
import '../congratulation_create_a_new_password_dialog/congratulation_create_a_new_password_dialog.dart';
import '../congratulation_profile_light_version_dialog/congratulation_profile_light_version_dialog.dart';
import '../if_otp_is_incorrect_light_version_dialog/if_otp_is_incorrect_light_version_dialog.dart';
import '../if_otp_is_incorrect_light_version_one_dialog/if_otp_is_incorrect_light_version_one_dialog.dart';
import 'bloc/app_navigation_bloc.dart';
import 'models/app_navigation_model.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<AppNavigationBloc>(
      create: (context) => AppNavigationBloc(
        AppNavigationState(appNavigationModelObj: AppNavigationModel()),
      )..add(AppNavigationInitialEvent()),
      child: const AppNavigationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppNavigationBloc, AppNavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SafeArea(
            child: SizedBox(
              width: 375.h,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: const Text(
                            "App Navigation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF880008),
                              fontSize: 20,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Padding(
                          padding: EdgeInsets.only(left: 20.h),
                          child: const Text(
                            "Check your app's UI from the below demo screens of your app.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFEEEEEE),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
                        child: Column(
                          children: [
                            _buildScreenTitle(
                              context,
                              screenTitle: "Create Profile Light Version",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.createProfileLightVersionScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "iPhone 14 - FortySix",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.iphone14FortysixScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "iPhone 14 - FortyFour",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.iphone14FortyfourScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Login Light Version",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.loginLightVersionScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "IF OTP is incorrect Light Version - Dialog",
                              onTapScreenTitle: () => onTapDialogTitle(
                                context,
                                IfOtpIsIncorrectLightVersionDialog.builder(context),
                              ),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Congratulation Create a New Password - Dialog",
                              onTapScreenTitle: () => onTapDialogTitle(
                                context,
                                CongratulationCreateANewPasswordDialog.builder(context),
                              ),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Create a New Password Light Version",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.createANewPasswordLightVersionScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "OTP Light Version",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.otpLightVersionScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Forgot Password Light Version",
                              onTapScreenTitle: () => onTapScreenTitle(AppRoutes.forgotPasswordLightVersionScreen),
                            ),
                            _buildScreenTitle(
                              context,
                              screenTitle: "Congratulation Profile Light Version - Dialog",
                              onTapScreenTitle: () => onTapDialogTitle(
                                context,
                                CongratulationProfileLightVersionDialog.builder(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
/// Common click event for dialog
void onTapDialogTitle(BuildContext context, Widget className) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: className,
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
      );
    },
  );
}
/// Common widget
Widget _buildScreenTitle(
  BuildContext context, {
  required String screenTitle,
  Function? onTapScreenTitle,
}) {
  return GestureDetector(
    onTap: () {
      onTapScreenTitle?.call();
    },
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Text(
              screenTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF000000),
                fontSize: 20.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(height: 5.h),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: const Color(0xFF888888),
          ),
        ],
      ),
    ),
  );
}
/// Common click event
void onTapScreenTitle(String routeName) {
  NavigatorService.pushNamed(routeName);
}
