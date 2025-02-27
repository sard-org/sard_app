import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../../widgets/app_bar/appbar_trailing_image_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_search_view.dart';
import 'bloc/login_light_version_bloc.dart';
import 'loginlight_tab_page.dart';
import 'models/login_light_version_model.dart';

class LoginLightVersionScreen extends StatefulWidget {
  const LoginLightVersionScreen({Key? key}) : super(key: key);

  @override
  LoginLightVersionScreenState createState() => LoginLightVersionScreenState();

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginLightVersionBloc>(
      create: (context) => LoginLightVersionBloc(LoginLightVersionState(
        loginLightVersionModelObj: LoginLightVersionModel(),
      ))..add(LoginLightVersionInitialEvent()),
      child: LoginLightVersionScreen(),
    );
  }
}

// ignore_for_file: must_be_immutable
class LoginLightVersionScreenState extends State<LoginLightVersionScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  int tabIndex = 0;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 4.h),
              _buildUserProgressSection(context),
              SizedBox(height: 14.h),
              _buildTabview(context),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12.h),
                  child: TabBarView(
                    controller: tabviewController,
                    children: [
                      Container(),
                      Container(),
                      Container(),
                      LoginlightTabPage.builder(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 12.h),
        child: _buildBottomNavigation(context),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 46.h,
      leadingWidth: 52.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgMegaphone,
        margin: EdgeInsets.only(left: 16.h, bottom: 10.h),
      ),
      actions: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "lbl15".tr,
                style: CustomTextStyles.bodyLargeCairoGray60002,
              ),
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
          margin: EdgeInsets.only(left: 6.h, right: 16.h),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildUserProgressSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 28.h, right: 18.h),
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
                      TextSpan(
                        text: "msg20".tr,
                        style: CustomTextStyles.labelMediumCairo,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16.h),
      width: double.maxFinite,
      child: TabBar(
        controller: tabviewController,
        labelPadding: EdgeInsets.zero,
        labelColor: theme.colorScheme.onPrimary,
        labelStyle: TextStyle(
          fontSize: 12.fSize,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: theme.colorScheme.onPrimary,
        unselectedLabelStyle: TextStyle(
          fontSize: 12.fSize,
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            height: 42,
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              margin: EdgeInsets.only(right: 6.h),
              decoration: tabIndex == 0
                  ? BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.h),
                      border: Border.all(
                        color: appTheme.gray40002,
                        width: 1.h,
                      ),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(8.h),
                      border: Border.all(
                        color: appTheme.gray40002,
                        width: 1.h,
                      ),
                    ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("1b120".tr),
                  CustomImageView(
                    imagePath: ImageConstant.imgPrinter,
                    height: 22.h,
                    width: 18.h,
                  ),
                ],
              ),
            ),
          ),
        ],
        indicatorColor: Colors.transparent,
        onTap: (index) {
          tabIndex = index;
          setState(() {});
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildBottomNavigation(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {},
      ),
    );
  }
}