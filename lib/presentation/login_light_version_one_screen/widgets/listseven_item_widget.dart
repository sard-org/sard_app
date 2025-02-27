import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listseven_item_model.dart';

// ignore_for_file: must_be_immutable
class ListsevenItemWidget extends StatelessWidget {
  ListsevenItemWidget(this.listsevenItemModelObj, {Key? key}) : super(key: key);

  ListsevenItemModel listsevenItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: AppDecoration.outlineBlueGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          SizedBox(
            height: 130.h,
            width: 102.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imageCat0200004,
                  height: 130.h,
                  width: double.maxFinite,
                  radius: BorderRadius.circular(4.h),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 2.h, right: 6.h),
                          padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                          decoration: AppDecoration.fillLine.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                listsevenItemModelObj.seven1,
                                style: theme.textTheme.labelMedium,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imageOn,
                                height: 14.h,
                                width: 14.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 12.h),
              child: Text(
                listsevenItemModelObj.tfl,
                style: CustomTextStyles.bodySmallSecondaryContainer,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            listsevenItemModelObj.tfl1,
            textAlign: TextAlign.right,
            style: CustomTextStyles.titleMediumOnPrimary,
          ),
        ],
      ),
    );
  }
}