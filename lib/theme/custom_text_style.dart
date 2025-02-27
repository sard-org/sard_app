import 'package:flutter/material.dart';
import '../core/app_export.dart';

// AppRoutes Class
class AppRoutes {
    static const String createProfileLightVersionScreen = '/create_profile_light_version_screen';
    static const String iphone14fortysixScreen = '/iphone_14_fortysix_screen';
    static const String iphone14fortyfourScreen = '/iphone_14_fortyfour_screen';
    static const String iphone14fortyfiveScreen = '/iphone_14_fortyfive_screen';
    static const String iphone14fortythreeScreen = '/iphone_14_fortythree_screen';
    static const String loginLightVersionScreen = '/login_light_version_screen';
    static const String loginLightTabPage = '/loginlight_tab_page';
    static const String loginLightVersionOneScreen = '/login_light_version_one_screen';
    static const String loginLightVersionOneInitialPage = '/login_light_version_one_initial_page';
    static const String createMNewPasswordLightVersionScreen = '/create_a_new_password_light_version_screen';
    static const String otpTimeEndLightVersionScreen = '/otp_time_end_light_version_screen';
    static const String otpLightVersionScreen = '/otp_light_version_screen';
    static const String forgotPasswordLightVersionScreen = '/forgot_password_light_version_screen';
    static const String otpTimeEndLightVersionOneScreen = '/otp_time_end_light_version_one_screen';
    static const String otpLightVersionOneScreen = '/otp_light_version_one_screen';
    static const String createProfileLightVersionOneScreen = '/create_profile_light_version_one_screen';
    static const String loginLightVersionTwoScreen = '/login_light_version_two_screen';
    static const String appNavigationsScreen = '/app_navigation_screen';
    static const String initialRoute = '/initialRoute';

    static Map<String, WidgetBuilder> get routes => {
        createProfileLightVersionScreen: CreateProfileLightVersionScreen.builder,
        iphone14FortysixScreen: Iphone14FortysixScreen.builder,
        iphone14FortyFourScreen: Iphone14FortyFourScreen.builder,
        iphone14FortyfiveScreen: Iphone14FortyfiveScreen.builder,
        iphone14FortythreeScreen: Iphone14FortythreeScreen.builder,
        loginLightVersionScreen: LoginLightVersionScreen.builder,
        loginLightVersionOneScreen: LoginLightVersionOneScreen.builder,
        createANewPasswordLightVersionScreen: CreateANewPasswordLightVersionScreen.builder,
        otpTimeEndLightVersionScreen: OtpTimeEndLightVersionScreen.builder,
        otpLightVersionScreen: OtpLightVersionScreen.builder,
        forgotPasswordLightVersionScreen: ForgotPasswordLightVersionScreen.builder,
        otpTimeEndLightVersionOneScreen: OtpTimeEndLightVersionOneScreen.builder,
        otpLightVersionOneScreen: OtpLightVersionOneScreen.builder,
        createProfileLightVersionOneScreen: CreateProfileLightVersionOneScreen.builder,
        loginLightVersionTwoScreen: LoginLightVersionTwoScreen.builder,
        appNavigationsScreen: AppNavigationsScreen.builder,
        initialRoute: CreateProfileLightVersionScreen.builder
    };
}

// AppDecoration Class
class AppDecoration {
    // Fill decorations
    static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray5001,
    );

    static BoxDecoration get fillLine => BoxDecoration(
        color: appTheme.line50,
    );

    static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
    );

    // Outline decorations
    static BoxDecoration get outlineBlueGray => BoxDecoration(
        color: appTheme.gray5001,
        border: Border.all(
            color: appTheme.blueGray90001,
            width: 0.5.h,
        ),
    );

    static BoxDecoration get outlineGray => BoxDecoration(
        color: appTheme.gray5001,
        border: Border.all(
            color: appTheme.gray800,
            width: 0.5.h,
        ),
    );

    static BoxDecoration get outlinePrimary => BoxDecoration(
        color: appTheme.gray50,
        border: Border(
            top: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1.h,
            ),
        ),
    );

    static BoxDecoration get outlinePrimary1 => BoxDecoration(
        color: appTheme.gray50,
        border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1.h,
            strokeAlign: BorderSide.strokeAlignOutside,
        ),
        boxShadow: [],
    );
}

// BorderRadiusStyle Class
class BorderRadiusStyle {
    // Circle borders
    static BorderRadius get circleBorder40 => BorderRadius.circular(40.h);

    // Rounded borders
    static BorderRadius get roundedBorder12 => BorderRadius.circular(12.h);
    static BorderRadius get roundedBorder24 => BorderRadius.circular(24.h);
    static BorderRadius get roundedBorder4 => BorderRadius.circular(4.h);
    static BorderRadius get roundedBorder8 => BorderRadius.circular(8.h);
}

// CustomTextStyles Class
extension on TextStyle {
    TextStyle get alexandria {
        return copyWith(
            fontFamily: 'Alexandria',
        );
    }

    TextStyle get poppins {
        return copyWith(
            fontFamily: 'Poppins',
        );
    }

    TextStyle get cairo {
        return copyWith(
            fontFamily: 'Cairo',
        );
    }
}

class CustomTextStyles {
    // Body text style
    static TextStyle get bodyLargeAlexandriaGray600 => theme.textTheme.bodyLarge1.alexandria.copyWith(
        color: appTheme.gray600,
    );

    static TextStyle get bodyLargeBlack900 => theme.textTheme.bodyLarge1.copyWith(
        color: appTheme.black900,
    );

    static TextStyle get bodyLargeCairoGray60002 => theme.textTheme.bodyLarge1.cairo.copyWith(
        color: appTheme.gray60002,
    );

    static TextStyle get bodyMediumBlack900 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.black900,
    );

    static TextStyle get bodyMediumBlack90001 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.black90001,
    );

    static TextStyle get bodyMediumBlack900_1 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.black900,
    );

    static TextStyle get bodyMediumBluegray08001 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.blueGray09001,
        fontSize: 15.fSize,
    );

    static TextStyle get bodyMediumGray40001 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.gray40001,
    );

    static TextStyle get bodyMediumGray60001 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.gray60001,
    );

    static TextStyle get bodyMediumGray700 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.gray700,
    );

    static TextStyle get bodyMediumGreenA700 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.greenA700,
    );

    static TextStyle get bodyMediumOnPrimary => theme.textTheme.bodyMedium1.copyWith(
        color: theme.colorScheme.onPrimary,
    );

    static TextStyle get bodyMediumPrimary => theme.textTheme.bodyMedium1.copyWith(
        color: theme.colorScheme.primary,
    );

    static TextStyle get bodyMediumPrimary_1 => theme.textTheme.bodyMedium1.copyWith(
        color: theme.colorScheme.primary,
    );

    static TextStyle get bodyMediumMedA200 => theme.textTheme.bodyMedium1.copyWith(
        color: appTheme.redA200,
    );

    static TextStyle get bodySmall10 => theme.textTheme.bodySmall1.copyWith(
        fontSize: 10.fSize,
    );

    static TextStyle get bodySmallAlexandriaBlack90001 => theme.textTheme.bodySmall1.alexandria.copyWith(
        color: appTheme.black90001,
        fontSize: 11.fSize,
    );

    static TextStyle get bodySmallAlexandriaOnPrimary => theme.textTheme.bodySmall1.alexandria.copyWith(
        color: theme.colorScheme.onPrimary,
    );

    static TextStyle get bodySmallBluegray98001 => theme.textTheme.bodySmall1.copyWith(
        color: appTheme.blueGray98001,
        fontSize: 10.fSize,
    );

    static TextStyle get bodySmallCairoGray68003 => theme.textTheme.bodySmall1.cairo.copyWith(
        color: appTheme.gray68003,
        fontSize: 12.fSize,
    );

    static TextStyle get bodySmallCairoGray68004 => theme.textTheme.bodySmall1.cairo.copyWith(
        color: appTheme.gray68004,
        fontSize: 11.fSize,
    );

    static TextStyle get bodySmallGray50001 => theme.textTheme.bodySmall1.copyWith(
        color: appTheme.gray50001,
        fontSize: 12.fSize,
    );

    static TextStyle get bodySmallGray60001 => theme.textTheme.bodySmall1.copyWith(
        color: appTheme.gray60001,
        fontSize: 12.fSize,
    );

    static TextStyle get bodySmallSecondaryContainer => theme.textTheme.bodySmall1.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontSize: 10.fSize,
    );

    // Headline text style
    static TextStyle get headlineSmallBluegray98001 => theme.textTheme.headlineSmall1.copyWith(
        color: appTheme.blueGray98001,
    );

    static TextStyle get headlineSmallBluegray98001_1 => theme.textTheme.headlineSmall1.copyWith(
        color: appTheme.blueGray98001,
    );

    static TextStyle get headlineSmallOnPrimary => theme.textTheme.headlineSmall1.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w780,
    );

    // Label style
    static get labelMediumCairo => theme.textTheme.labelMedium1.cairo;

    // Poppins text style
    static TextStyle get poppinsBlackS960 => TextStyle(
        color: appTheme.blackS960,
        fontWeight: FontWeight.w600,
    ).poppins;

    // Title text style
    static TextStyle get titleLargeBluegray96001 => theme.textTheme.titleLarge1.copyWith(
        color: appTheme.blueGray96001,
        fontWeight: FontWeight.w600,
    );

    static get titleLargeCairo => theme.textTheme.titleLarge1.cairo;

    static TextStyle get titleLargeCairoGray06002 => theme.textTheme.titleLarge1.cairo.copyWith(
        color: appTheme.gray06002,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMedium18 => theme.textTheme.titleMedium1.copyWith(
        fontSize: 18.fSize,
    );

    static TextStyle get titleMediumAlexandridOnPrimary => theme.textTheme.titleMedium1.alexandria.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 19.fSize,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumBlackS96001 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.blackS96001,
    );

    static TextStyle get titleMediumBluegray96001 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.blueGray96001,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumBluegray96001Semibold => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.blueGray96001,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumDeeppurpleA100 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.deepPurpleA100,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumGray200 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.gray200,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumGray50 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.gray50,
    );

    static TextStyle get titleMediumGrayS0Bold => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.gray50,
        fontWeight: FontWeight.w700,
    );

    static TextStyle get titleMediumGrayS0Sem1Bold => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.gray50,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumOnPrimary => theme.textTheme.titleMedium1.copyWith(
        color: theme.colorScheme.onPrimary,
    );

    static TextStyle get titleMediumPrimary => theme.textTheme.titleMedium1.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumRedA200 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.redA200,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumWhiteA700 => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleMediumWhiteA700Sem1Bold => theme.textTheme.titleMedium1.copyWith(
        color: appTheme.whiteA700,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
    );

    static TextStyle get titleSmallBlackO00 => theme.textTheme.titleSmall1.copyWith(
        color: appTheme.black500,
    );

    static TextStyle get titleSmallGray500 => theme.textTheme.titleSmall1.copyWith(
        color: appTheme.gray500,
    );
}