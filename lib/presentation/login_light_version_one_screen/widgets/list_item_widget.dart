import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/list_item_model.dart';

// ignore_for_file: must_be_immutable
class ListItemWidget extends StatelessWidget {
  ListItemWidget(this.listItemModelObj, {Key? key}) : super(key: key);

  ListItemModel listItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 684.h,
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          listItemModelObj.tf1,
                          textAlign: TextAlign.right,
                          style: CustomTextStyles.bodySmall10,
                        ),
                        Text(
                          listItemModelObj.tf11,
                          textAlign: TextAlign.right,
                          style: CustomTextStyles.bodyMediumBlack90001,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Text(
                            listItemModelObj.description1,
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
                        CustomImageView(
                          imagePath: ImageConstant.imgKat02000002,
                          height: 124.h,
                          width: 92.h,
                          radius: BorderRadius.circular(4.h),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.h,
                              vertical: 10.h,
                            ),
                            decoration: AppDecoration.outLineGray.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        listItemModelObj.rf21,
                                        style: CustomTextStyles.bodySmall10,
                                      ),
                                      SizedBox(height: 8.h),
                                      SizedBox(
                                        width: 152.h,
                                        child: Text(
                                          listItemModelObj.rf31,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.right,
                                          style: CustomTextStyles.bodyMediumBlack96001.copyWith(
                                            height: 1.50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        listItemModelObj.descriptionOne1,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: theme.textTheme.bodySmall1.copyWith(
                                          height: 1.50,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "lb1_396".tr,
                                              style: CustomTextStyles.titleMediumBluegray90001,
                                            ),
                                            TextSpan(
                                              text: "lb110".tr,
                                              style: CustomTextStyles.bodySmallBluegray90001,
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "lb1_396".tr,
                                style: CustomTextStyles.titleMediumBluegray90001,
                              ),
                              TextSpan(
                                text: "lb110".tr,
                                style: CustomTextStyles.bodySmallBluegray90001,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgKat0200002,
                          height: 124.h,
                          width: 92.h,
                          radius: BorderRadius.circular(4.h),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}