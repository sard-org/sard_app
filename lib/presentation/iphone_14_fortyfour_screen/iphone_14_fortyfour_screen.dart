import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_rating_bar.dart';
import 'bloc/iphone_14_fortyfour_bloc.dart';
import 'models/iphone_14_fortyfour_model.dart';

class Iphone14FortyfourScreen extends StatelessWidget {
  const Iphone14FortyfourScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<Iphone14FortyfourBloc>(
      create: (context) => Iphone14FortyfourBloc(
        Iphone14FortyfourState(
          iphone14FortyfourModelobj: Iphone14FortyfourModel(),
        ),
      )..add(Iphone14FortyfourInitialEvent()),
      child: const Iphone14FortyfourScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Iphone14FortyfourBloc, Iphone14FortyfourState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: appTheme.gray5001,
          appBar: _buildAppBar(context),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  _buildBookImage(),
                  SizedBox(height: 20.h),
                  _buildBookDetails(context),
                  SizedBox(height: 20.h),
                  _buildMoreBooksRow(context),
                  SizedBox(height: 12.h),
                  _buildRecommendedBooksScroll(context),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildInsufficientPointsColumn(context),
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

  Widget _buildBookImage() {
    return Container(
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
    );
  }

  Widget _buildBookDetails(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
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
                buttonStyle: CustomButtonStyles.filllime,
                buttonTextStyle: CustomTextStyles.titleMediumAlexandriaOnPrimary,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "lbl7".tr,
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
          SizedBox(height: 2.h),
          Text(
            "msg9".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: CustomTextStyles.headlineSmallOnPrimary.copyWith(height: 1.50),
          ),
          SizedBox(height: 2.h),
          Text(
            "msg10".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: CustomTextStyles.bodyMediumGray60001.copyWith(height: 1.50),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "lbl_54".tr,
                style: CustomTextStyles.bodySmallGray50001,
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.h),
                child: CustomRatingBar(initialRating: 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoreBooksRow(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("lbl8".tr, style: CustomTextStyles.bodySmallGray60001),
          Text("lbl9".tr, style: CustomTextStyles.titleMediumBlack90001),
        ],
      ),
    );
  }

  Widget _buildRecommendedBooksScroll(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildBookCard("msg11".tr, "msg12".tr, "msg13".tr),
            SizedBox(width: 8.h),
            _buildBookCard("msg11".tr, "msg14".tr, "msg13".tr),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(String title, String description, String price) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.outlineGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title, style: CustomTextStyles.bodySmall10),
          SizedBox(height: 8.h),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: CustomTextStyles.bodyMediumBlack90001.copyWith(height: 1.50),
          ),
          SizedBox(height: 6.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "lbl_396".tr, style: CustomTextStyles.titleMediumBluegray90001),
                TextSpan(text: "lbl10".tr, style: CustomTextStyles.bodySmallBluegray90001),
              ],
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 8.h),
          CustomImageView(
            imagePath: ImageConstant.imgkat0200002,
            height: 124.h,
            width: 92.h,
            radius: BorderRadius.circular(4.h),
          ),
        ],
      ),
    );
  }

  Widget _buildInsufficientPointsColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            height: 56.h,
            text: "msg16".tr,
            buttonStyle: CustomButtonStyles.fillGray,
            buttonTextStyle: CustomTextStyles.titleMediumGray200,
          ),
          SizedBox(height: 8.h),
          CustomOutlinedButton(
            height: 56.h,
            text: "msg15".tr,
            rightIcon: CustomImageView(
              imagePath: ImageConstant.imgTelevision,
              height: 24.h,
              width: 24.h,
              fit: BoxFit.contain,
            ),
            buttonTextStyle: CustomTextStyles.titleMediumDeeppurpleA100,
          ),
        ],
      ),
    );
  }
}
