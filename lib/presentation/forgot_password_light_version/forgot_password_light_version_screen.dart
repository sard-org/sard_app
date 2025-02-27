import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'bloc/forgot_password_light_version_bloc.dart';
import 'models/forgot_password_light_version_model.dart';

class ForgotPasswordLightVersionScreen extends StatelessWidget {
  const ForgotPasswordLightVersionScreen({Key? key})
      : super(
          key: key,
        );

  static Widget builder(BuildContext context) {
    return BlocProvider<ForgotPasswordLightVersionBloc>(
      create: (context) =>
          ForgotPasswordLightVersionBloc(ForgotPasswordLightVersionState(
        forgotPasswordLightVersionModelObj: ForgotPasswordLightVersionModel(),
      ))
            ..add(ForgotPasswordLightVersionInitialEvent()),
      child: ForgotPasswordLightVersionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 16.h,
                    top: 32.h,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 16.h,
                    top: 32.h,
                    right: 16.h,
                  ),
                  child: Column(
                    spacing: 26,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _buildColumnheading(context),
                      _buildColumnheading1(context)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildColumn(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(right: 18.h),
        )
      ],
    );
        child: SizedBox(
        top: false,
      body: SafeArea(
      appBar: _buildAppbar(context),
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.gray50,
    return Scaffold(
      bottomNavigationBar: _buildColumn(context),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(right: 18.h),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildColumnheading(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        spacing: 6,
        children: [
          Text(
            "msg40".tr,
            style: theme.textTheme.headlineSmall,
          ),
          Text(
            "msg2".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnheading1(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.end,
        AppbarTrailingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(right: 18.h),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildColumnheading(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        spacing: 6,
        children: [
          Text(
            "msg40".tr,
            style: theme.textTheme.headlineSmall,
          ),
          Text(
            "msg2".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnheading1(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "msg3".tr,
            style: theme.textTheme.titleMedium,
          ),
          BlocSelector<ForgotPasswordLightVersionBloc,
              ForgotPasswordLightVersionState, TextEditingController?>(
            selector: (state) => state.framethirtyeighController,

  /// Section Widget
  Widget _buildColumnheading1(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "msg3".tr,
            style: theme.textTheme.titleMedium,
          ),
          BlocSelector<ForgotPasswordLightVersionBloc,
              ForgotPasswordLightVersionState, TextEditingController?>(
            selector: (state) => state.framethirtyeighController,
            builder: (context, framethirtyeighController) {
              return CustomTextFormField(
                controller: framethirtyeighController,
                hintText: "msg4".tr,
                textInputAction: TextInputAction.done,
                contentPadding: EdgeInsets.all(12.h),
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "lbl4".tr,
            margin: EdgeInsets.only(bottom: 12.h),
            onPressed: () {
              onTaptf(context);
  }
    );
      ),
              );
            },
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "lbl4".tr,
            margin: EdgeInsets.only(bottom: 12.h),
            onPressed: () {
              onTaptf(context);
            },
          )
        ],
      ),
    );
  }

  /// Navigates to the otpLightVersionOneScreen when the action is triggered.
  onTaptf(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.otpLightVersionOneScreen,
    );
  }
}

