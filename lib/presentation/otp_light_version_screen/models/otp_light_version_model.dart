import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_pin_code_text_field.dart';
import 'bloc/otp_light_version_bloc.dart';
import 'models/otp_light_version_model.dart';

class OtpLightVersionScreen extends StatelessWidget {
  const OtpLightVersionScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<OtpLightVersionBloc>(
      create: (context) => OtpLightVersionBloc(OtpLightVersionState(
        otpLightVersionModelObj: OtpLightVersionModel(),
      ))..add(OtpLightVersionInitialEvent()),
      child: OtpLightVersionScreen(),
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
                    left: 38.h,
                    top: 32.h,
                    right: 38.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "lb13".tr,
                        style: theme.textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "msg35".tr,
                              style: theme.textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: "lb1_uxu1_gmail_com".tr,
                              style: CustomTextStyles.bodyLargeBlack900,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 28.h),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                          left: 14.h,
                          right: 26.h,
                        ),
                        child: BlocSelector<OtpLightVersionBloc, OtpLightVersionState, TextEditingController>(
                          selector: (state) => state.otpController,
                          builder: (context, otpController) {
                            return CustomPinCodeTextField(
                              context: context,
                              controller: otpController,
                              onChanged: (value) {
                                otpController?.text = value;
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "msg37".tr,
                              style: CustomTextStyles.bodyMediumBlackS90_1,
                            ),
                            TextSpan(
                              text: "lb1_10_m_005".tr,
                              style: CustomTextStyles.bodyMediumPrimary,
                            ),
                            TextSpan(
                              text: "lb134".tr,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildColumn(context),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 38.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(left: 18.h),
      ),
    );
  }

  // Section Widget
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "lb136".tr,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    onTapRowIconone(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgIconPrimary,
                        height: 20.h,
                        width: 20.h,
                      ),
                      Text(
                        "lbl5".tr,
                        style: theme.textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            "msg39".tr,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Navigates to the loginLightVersionTwoScreen when the action is triggered.
  onTapRowIconone(BuildContext context) {
    NavigatorService.pushNamed(
      AppRoutes.loginLightVersionTwoScreen,
    );
  }
}