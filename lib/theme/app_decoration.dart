import 'package:flutter/material.dart';
import '../core/app_export.dart';

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

class BorderRadiusStyle {
    // Circle borders
    static BorderRadius get circleBorder40 => BorderRadius.circular(40.h);

    // Rounded borders
    static BorderRadius get roundedBorder12 => BorderRadius.circular(12.h);
    static BorderRadius get roundedBorder24 => BorderRadius.circular(24.h);
    static BorderRadius get roundedBorder4 => BorderRadius.circular(4.h);
    static BorderRadius get roundedBorder8 => BorderRadius.circular(8.h);
}