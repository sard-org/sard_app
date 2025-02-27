import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton {
    static BoxDecoration get outlineGrayIL14 => BoxDecoration(
        borderRadius: BorderRadius.circular(14.h),
        border: Border.all(
            color: appTheme.gray500,
            width: 1.h,
        ),
    );

    static BoxDecoration get fillRedA => BoxDecoration(
        color: appTheme.redA200,
        borderRadius: BorderRadius.circular(14.h),
    );

    static BoxDecoration get fillGreenA => BoxDecoration(
        color: appTheme.greenA700,
        borderRadius: BorderRadius.circular(14.h),
    );

    static BoxDecoration get outlineGreenA => BoxDecoration(
        color: appTheme.gray50,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
            color: appTheme.greenA700.withOpacity(0.6),
            width: 1.h,
        ),
        boxShadow: [
            BoxShadow(
                spreadRadius: 2.h,
                blurRadius: 2.h,
            ),
        ],
    );

    static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
    CustomIconButton({
        Key? key,
        this.alignment,
        this.height,
        this.width,
        this.decoration,
        this.padding,
        this.onTap,
        this.child,
    }) : super(key: key);

    final Alignment? alignment;
    final double? height;
    final double? width;
    final BoxDecoration? decoration;
    final EdgeInsetsGeometry? padding;
    final VoidCallback? onTap;
    final Widget? child;

    @override
    Widget build(BuildContext context) {
        return alignment != null
            ? Align(
                alignment: alignment ?? Alignment.center,
                child: iconButtonWidget,
            )
            : iconButtonWidget;
    }

    Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
            decoration: decoration ??
                BoxDecoration(
                    borderRadius: BorderRadius.circular(4.h),
                    border: Border.all(
                        color: appTheme.gray400,
                        width: 0.h,
                    ),
                ),
            child: IconButton(
                padding: padding ?? EdgeInsets.zero,
                onPressed: onTap,
                icon: child ?? Container(),
            ),
        ),
    );
}