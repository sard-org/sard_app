import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppbarTrailingImageOne extends StatelessWidget {
    AppbarTrailingImageOne({
        Key? key,
        this.imagePath,
        this.height,
        this.width,
        this.onTap,
        this.margin,
    }) : super(key: key);

    final double? height;
    final double? width;
    final String? imagePath;
    final Function? onTap;
    final EdgeInsetsGeometry? margin;

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: margin ?? EdgeInsets.zero,
            child: InkWell(
                borderRadius: BorderRadiusStyle.roundedBorder12,
                onTap: () {
                    onTap?.call();
                },
                child: CustomImageView(
                    imagePath: imagePath ?? ImageConstant.imgArrowLeft,
                    height: height ?? 20.h,
                    width: width ?? 20.h,
                    fit: BoxFit.contain,
                    radius: BorderRadius.circular(14.h),
                ),
            ),
        );
    }
}