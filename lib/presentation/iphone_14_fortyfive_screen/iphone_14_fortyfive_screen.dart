import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_rating_bar.dart';
import 'bloc/iphone_14_fortyfive_bloc.dart';
import 'models/iphone_14_fortyfive_model.dart';

class Iphone14FortyfiveScreen extends StatelessWidget {
  const Iphone14FortyfiveScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<Iphone14FortyfiveBloc>(
      create: (context) => Iphone14FortyfiveBloc(Iphone14FortyfiveState(
        iphone14FortyfiveModelObj: Iphone14FortyfiveModel(),
      ))..add(Iphone14FortyfiveInitialEvent()),
      child: Iphone14FortyfiveScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Iphone14FortyfiveBloc, Iphone14FortyfiveState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: appTheme.gray5001,
          appBar: _buildAppBar(context),
          body: SafeArea(
            top: false,
            child: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(right: 16.h),
                        child: Column(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgkat0200004,
                              height: 226.h,
                              width: 160.h,
                              radius: BorderRadius.circular(4.h),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      _buildBookDetails(context),
                      SizedBox(height: 20.h),
                      _buildSuggestedBooks(context),
                      SizedBox(height: 12.h),
                      _buildHorizontalBookScroll(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildActionButtons(context),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 56.h,
      actions: [
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgArrowLeft,
          margin: EdgeInsets.only(top: 9.h, right: 15.h, bottom: 10.h),
        ),
      ],
    );
  }

  Widget _buildBookDetails(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomElevatedButton(
                  height: 38.h,
                  width: 70.h,
                  text: "lbl_72".tr,
                  rightIcon: Container(
                    margin: EdgeInsets.only(left: 8.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgClose,
                      height: 22.h,
                      width: 22.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.fillLime,
                  buttonTextStyle: CustomTextStyles.titleMediumAlexandriaOnPrimary,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "1b17".tr,
                        style: CustomTextStyles.bodyLargeAlexandriaGray600,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgWriter,
                        height: 30.h,
                        width: 30.h,
                        radius: BorderRadius.circular(14.h),
                        margin: EdgeInsets.only(left: 8.h),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: 254.h,
            child: Text(
              "msg9".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: CustomTextStyles.headlineSmallOnPrimary.copyWith(height: 1.50),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "msg18".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: CustomTextStyles.bodyMediumGray60001.copyWith(height: 1.50),
          ),
          SizedBox(height: 6.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "lbl_54".tr,
                  style: CustomTextStyles.bodySmallGray50001,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: CustomRatingBar(
                    initialRating: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedBooks(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "1b18".tr,
            style: CustomTextStyles.bodySmallGray60001,
          ),
          Text(
            "1b19".tr,
            style: CustomTextStyles.titleMediumBlack90001,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalBookScroll(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: SizedBox(
            width: 604.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: AppDecoration.outlineGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  spacing: 8,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "msg11".tr,
                                      textAlign: TextAlign.right,
                                      style: CustomTextStyles.bodySmall10,
                                    ),
                                    Text(
                                      "msg12".tr,
                                      textAlign: TextAlign.right,
                                      style: CustomTextStyles.bodyMediumBlack90001,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  "msg13".tr,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "lbl_396".tr,
                                      style: CustomTextStyles.titleMediumBluegray90001,
                                    ),
                                    TextSpan(
                                      text: "lbl10".tr,
                                      style: CustomTextStyles.bodySmallBluegray90001,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgkat0200002,
                          height: 124.h,
                          width: 92.h,
                          radius: BorderRadius.circular(4.h),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8.h),
                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 10.h),
                    decoration: AppDecoration.outlineGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "msg11".tr,
                                style: CustomTextStyles.bodySmall10,
                              ),
                              SizedBox(height: 8.h),
                              SizedBox(
                                width: 152.h,
                                child: Text(
                                  "msg14".tr,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: CustomTextStyles.bodyMediumBlack90001.copyWith(height: 1.50),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "msg13".tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: theme.textTheme.bodySmall!.copyWith(height: 1.50),
                              ),
                              SizedBox(height: 6.h),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "lbl_396".tr,
                                      style: CustomTextStyles.titleMediumBluegray96001,
                                    ),
                                    TextSpan(
                                      text: "lbl10".tr,
                                      style: CustomTextStyles.bodySmallBluegray96001,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imageXat0200002,
                          height: 124.h,
                          width: 92.h,
                          radius: BorderRadius.circular(-4.h),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButtons(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 56.h,
            text: "msg18".tr,
            buttonTextStyle: CustomTextStyles.titleMediumWhiteA700,
          ),
          CustomOutlinedButton(
            height: 56.h,
            text: "msg15".tr,
            rightIcon: Container(
              margin: EdgeInsets.only(left: 8.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgTelevision,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.contains,
              ),
            ),
            buttonTextStyle: CustomTextStyles.titleMediumDeeppurpleA100,
          ),
        ],
      ),
    );
  }
}