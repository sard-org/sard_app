import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum { tf }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatefulWidget {
    CustomBottomBar({this.onChanged});
    Function(BottomBarEnum)? onChanged;

    @override
    CustomBottomBarState createState() => CustomBottomBarState();
}

// ignore_for_file: must_be_immutable
class CustomBottomBarState extends State<CustomBottomBar> {
    int selectedIndex = 0;

    List<BottomMenuModel> bottomMenuList = [
        BottomMenuModel(
            icon: ImageConstant.imgWav,
            activeIcon: ImageConstant.imgWav,
            title: "1b123".tr,
            type: BottomBarEnum.tf,
        ),
        BottomMenuModel(
            icon: ImageConstant.imgWavGray700,
            activeIcon: ImageConstant.imgWavGray700,
            title: "1b124".tr,
            type: BottomBarEnum.tf,
        ),
        BottomMenuModel(
            icon: ImageConstant.imgWavGray70028x28,
            activeIcon: ImageConstant.imgWavGray70028x28,
            title: "1b125".tr,
            type: BottomBarEnum.tf,
        ),
        BottomMenuModel(
            icon: ImageConstant.imgWavOnprimarycontainer,
            activeIcon: ImageConstant.imgWavOnprimarycontainer,
            title: "1b126".tr,
            type: BottomBarEnum.tf,
        )
    ];

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: appTheme.gray400,
                        width: 0.5.h,
                    ),
                ),
            ),
            child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedFontSize: 0,
                elevation: 0,
                currentIndex: selectedIndex,
                type: BottomNavigationBarType.fixed,
                items: List.generate(bottomMenuList.length, (index) {
                    return BottomNavigationBarItem(
                        icon: SizedBox(
                            width: double.maxFinite,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    CustomImageView(
                                        imagePath: bottomMenuList[index].icon,
                                        height: 28.h,
                                        width: 28.h,
                                        color: appTheme.gray700,
                                    ),
                                    Text(
                                        bottomMenuList[index].title ?? "",
                                        style: CustomTextStyles.bodyMediumGray700.copyWith(
                                            color: appTheme.gray700,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        activeIcon: SizedBox(
                            width: double.maxFinite,
                            child: Stack(
                                alignment: Alignment.center,
                                children: [
                                    CustomImageView(
                                        imagePath: bottomMenuList[index].activeIcon,
                                        height: 28.h,
                                        width: 28.h,
                                        color: theme.colorScheme.onPrimaryContainer,
                                    ),
                                    CustomImageView(
                                        imagePath: bottomMenuList[index].activeIcon,
                                        height: 5.h,
                                        width: 4.h,
                                        color: theme.colorScheme.onPrimaryContainer,
                                        alignment: Alignment.bottomCenter,
                                        margin: EdgeInsets.only(bottom: 6.h),
                                    ),
                                ],
                            ),
                        ),
                        label: "",
                    );
                }),
                onTap: (index) {
                    selectedIndex = index;
                    widget.onChanged?.call(bottomMenuList[index].type);
                    setState(() {});
                },
            ),
        );
    }
}

// ignore_for_file: must_be_immutable
class BottomMenuModel {
    BottomMenuModel({
        required this.icon,
        required this.activeIcon,
        this.title,
        required this.type,
    });

    String icon;
    String activeIcon;
    String? title;
    BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
            color: Color(0xFFFFFFFF),
            padding: EdgeInsets.all(10),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(
                            'Please replace the respective Widget here',
                            style: TextStyle(
                                fontSize: 18,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}