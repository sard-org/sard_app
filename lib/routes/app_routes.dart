import 'package:flutter/material.dart';
import 'package:mohamed_s_application1/presentation/create_profile_light_version/create_profile_light_version_screen.dart';
import 'package:mohamed_s_application1/presentation/iphone_14_fortythree_screen%20/iphone_14_fortythree_screen.dart';
import 'package:mohamed_s_application1/presentation/login_light_version_screen/login_light_version_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/create_a_new_password_light_version_screen/create_a_new_password_light_version_screen.dart';
import '../presentation/create_profile_light_version_one_screen/create_profile_light_version_one_screen.dart';
import '../presentation/create_profile_light_version_screen/create_profile_light_version_screen.dart';
import '../presentation/forgot_password_light_version_screen/forgot_password_light_version_screen.dart';
import '../presentation/iphone_14_fortyfive_screen/iphone_14_fortyfive_screen.dart';
import '../presentation/iphone_14_fortyfour_screen/iphone_14_fortyfour_screen.dart';
import '../presentation/iphone_14_fortysix_screen/iphone_14_fortysix_screen.dart';
import '../presentation/iphone_14_fortythree_screen/iphone_14_fortythree_screen.dart';
import '../presentation/login_light_version_one_screen/login_light_version_one_screen.dart';
import './presentation/login_light_version_screen/login_light_version_screen.dart';
import '../presentation/login_light_version_two_screen/login_light_version_two_screen.dart';
import '../presentation/otp_light_version_one_screen/otp_light_version_one_screen.dart';
import '../presentation/otp_light_version_screen/otp_light_version_screen.dart';
import '../presentation/otp_time_end_light_version_one_screen/otp_time_end_light_version_one_screen.dart';
import '../presentation/otp_time_end_light_version_screen/otp_time_end_light_version_screen.dart';

class AppRoutes {
    static const String createProfileLightVersionScreen = 
    '/create_profile_light_version_screen';

    static const String iphone14fortysixScreen = '/iphone_14_fortysix_screen';

    static const String iphone14fortyfourScreen = '/iphone_14_fortyfour_screen';

    static const String iphone14fortyfiveScreen = '/iphone_14_fortyfive_screen';

    static const String iphone14fortythreeScreen = '/iphone_14_fortythree_screen';

    static const String loginLightVersionScreen = '/login_light_version_screen';

    static const String loginLightTabPage = '/loginlight_tab_page';

    static const String loginLightVersionOneScreen = 
    '/login_light_version_one_screen';

    static const String loginLightVersionOneInitialPage = 
    '/login_light_version_one_initial_page';

    static const String createMNewPasswordLightVersionScreen = 
    '/create_a_new_password_light_version_screen';

    static const String otpTimeEndLightVersionScreen = 
    '/otp_time_end_light_version_screen';

    static const String otpLightVersionScreen = '/otp_light_version_screen';

    static const String forgotPasswordLightVersionScreen = '/forgot_password_light_version_screen';

    static const String otpTimeEndLightVersionOneScreen = 
    '/otp_time_end_light_version_one_screen';

    static const String otpLightVersionOneScreen = 
    '/otp_light_version_one_screen';

    static const String createProfileLightVersionOneScreen = 
    '/create_profile_light_version_one_screen';

    static const String loginLightVersionTwoScreen = 
    '/login_light_version_two_screen';

    static const String appNavigationsScreen = '/app_navigation_screen';

    static const String initialRoute = '/initialRoute';

    static Map<String, WidgetBuilder> get routes => {
        createProfileLightVersionScreen:
        CreateProfileLightVersionScreen.builder,
        iphone14fortysixScreen: Iphone_14_FortysixScreen.builder,
        iphone14fortyfourScreen: Iphone14FortyFourScreen.builder,
        iphone14FortyfiveScreen: Iphone14FortyfiveScreen.builder,
        iphone14FortythreeScreen: Iphone14FortythreeScreen.builder,
        loginLightVersionScreen: LoginLightVersionScreen.builder,
        loginLightVersionOneScreen: LoginLightVersionOneScreen.builder,
        createANewPasswordLightVersionScreen:
        CreateANewPasswordLightVersionScreen.builder,
        otpTimeEndLightVersionScreen: OtpTimeEndLightVersionScreen.builder,
        otpLightVersionScreen: OtpLightVersionScreen.builder,
        forgotPasswordLightVersionScreen:
        ForgotPasswordLightVersionScreen.builder,
        otpTimeEndLightVersionOneScreen:
        OtpTimeEndLightVersionOneScreen.builder,
        otpLightVersionOneScreen: OtpLightVersionOneScreen.builder,
        createProfileLightVersionOneScreen:
        CreateProfileLightVersionOneScreen.builder,
        loginLightVersionTwoScreen: LoginLightVersionTwoScreen.builder,
        appNavigationsScreen: AppNavigationsScreen.builder,
        initialRoute: CreateProfileLightVersionScreen.builder
    };
}