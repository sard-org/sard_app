import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_trailing_image_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_search_view.dart';
import 'bloc/login_light_version_one_bloc.dart';
import 'models/chipweiprinter_item_model.dart';
import 'models/list_item_model.dart';
import 'models/listseven_item_model.dart';
import 'models/login_light_version_one_initial_model.dart';
import 'widgets/chipweiprinter_item_widget.dart';
import 'widgets/list_item_widget.dart';
import 'widgets/listseven_item_widget.dart';

class LoginLightVersionOneInitialPage extends StatefulWidget {
  const LoginLightVersionOneInitialPage({Key? key}) : super(key: key);

  @override
  LoginLightVersionOneInitialPageState createState() =>
      LoginLightVersionOneInitialPageState();

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginLightVersionOneBloc>(
      create: (context) => LoginLightVersionOneBloc(
        LoginLightVersionOneState(
          loginLightVersionOneInitialModelObj:
              LoginLightVersionOneInitialModel(),
        ),
      )..add(LoginLightVersionOneInitialEvent()),
      child: const LoginLightVersionOneInitialPage(),
    );
  }
}

class LoginLightVersionOneInitialPageState
    extends State<LoginLightVersionOneInitialPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildAppbar(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 4.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildColumn(context),
                    _buildChipviewprinter(context),
                    _buildColumn1(context),
                    _buildColumn2(context),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildRow(
    BuildContext context, {
    required String one,
    required String prop,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          one,
          style: CustomTextStyles.bodySmallGray60001,
        ),
        Text(
          prop,
          style: CustomTextStyles.titleMediumBlack90001.copyWith(
            color: appTheme.black90001,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 46.h,
      leadingWidth: 52.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgMegaphone,
        margin: EdgeInsets.only(
          left: 16.h,
          bottom: 10.h,
        ),
      ),
      actions: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "lbl15".tr,
                style: CustomTextStyles.bodyLargeCairoGray60002,
              ),
              const TextSpan(text: " "),
              TextSpan(
                text: "lbl16".tr,
                style: CustomTextStyles.titleLargeCairo,
              ),
            ],
          ),
          textAlign: TextAlign.left,
        ),
        AppbarTrailingImageOne(
          imagePath: ImageConstant.imgStudent,
          height: 30.h,
          width: 30.h,
          margin: EdgeInsets.only(
            left: 6.h,
            right: 16.h,
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildColumn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 16.h,
        right: 18.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 22.h,
            width: 226.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "lbl18".tr,
                        style: CustomTextStyles.bodySmallCairoGray60003,
                      ),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: "msg20".tr,
                        style: CustomTextStyles.labelMediumCairo,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.img,
            height: 16.h,
            width: 12.h,
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 68.h),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomOutlinedButton(
                  height: 30.h,
                  width: 58.h,
                  text: "lbl_122".tr,
                  rightIcon: Container(
                    margin: EdgeInsets.only(left: 6.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgCoin,
                      height: 14.h,
                      width: 14.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.outlineBlueGray,
                  buttonTextStyle: CustomTextStyles.bodyMediumOnPrimary,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Spacer(),
                        CustomImageView(
                          imagePath: ImageConstant.imgUser,
                          height: 24.h,
                          width: 22.h,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUserGray200,
                          height: 28.h,
                          width: 30.h,
                          margin: EdgeInsets.only(left: 2.h),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUserGray200,
                          height: 28.h,
                          width: 30.h,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgUserGray200,
                          height: 28.h,
                          width: 30.h,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgPhBookFill,
                          height: 36.h,
                          width: 38.h,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgPhBookFillGreen50,
                          height: 28.h,
                          width: 30.h,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgPhBookFillGreen50,
                          height: 28.h,
                          width: 30.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocSelector<LoginLightVersionOneBloc, LoginLightVersionOneState,
              TextEditingController?>(
            selector: (state) => state.searchController,
            builder: (context, searchController) {
              return CustomSearchView(
                controller: searchController,
                hintText: "lbl19".tr,
                contentPadding:
                    EdgeInsets.fromLTRB(12.h, 10.h, 14.h, 10.h),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildChipviewprinter(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: BlocSelector<LoginLightVersionOneBloc, LoginLightVersionOneState,
          LoginLightVersionOneInitialModel?>(
        selector: (state) => state.loginLightVersionOneInitialModelObj,
        builder: (context, loginLightVersionOneInitialModelObj) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              direction: Axis.horizontal,
              runSpacing: 8.h,
              spacing: 8.h,
              children: List<Widget>.generate(
                loginLightVersionOneInitialModelObj
                        ?.chipviewprinterItemList.length ??
                    0,
                (index) {
                  ChipviewprinterItemModel model =
                      loginLightVersionOneInitialModelObj
                              ?.chipviewprinterItemList[index] ??
                          ChipviewprinterItemModel();
                  return ChipviewprinterItemWidget(model);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildColumn1(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(right: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(left: 16.h),
            child: _buildRow(
              context,
              one: "lbl18".tr,
              prop: "lbl27".tr,
            ),
          ),
          BlocSelector<LoginLightVersionOneBloc, LoginLightVersionOneState,
              LoginLightVersionOneInitialModel?>(
            selector: (state) => state.loginLightVersionOneInitialModelObj,
            builder: (context, loginLightVersionOneInitialModelObj) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: loginLightVersionOneInitialModelObj
                        ?.listItemList.length ??
                    0,
                itemBuilder: (context, index) {
                  ListItemModel model =
                      loginLightVersionOneInitialModelObj
                              ?.listItemList[index] ??
                          ListItemModel();
                  return ListItemWidget(model);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildColumn2(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 14.h),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildRow(
              context,
              one: "lbl18".tr,
              prop: "lbl28".tr,
            ),
          ),
          BlocSelector<LoginLightVersionOneBloc, LoginLightVersionOneState,
              LoginLightVersionOneInitialModel?>(
            selector: (state) => state.loginLightVersionOneInitialModelObj,
            builder: (context, loginLightVersionOneInitialModelObj) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 8.h,
                  children: List.generate(
                    loginLightVersionOneInitialModelObj
                            ?.listsevenItemList.length ??
                        0,
                    (index) {
                      ListsevenItemModel model =
                          loginLightVersionOneInitialModelObj
                                  ?.listsevenItemList[index] ??
                              ListsevenItemModel();
                      return ListsevenItemWidget(model);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}