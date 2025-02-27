import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/booklist_item_model.dart';

// ignore_for_file: must_be_immutable
class BooklistItemWidget extends StatelessWidget {
  BooklistItemWidget(this.booklistItemModelObj, {Key? key}) : super(key: key);

  BooklistItemModel booklistItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 152.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 24.h,
              width: 358.h,
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            margin: EdgeInsets.zero,
            color: appTheme.gray5001,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: appTheme.gray800,
                width: 0.5.h,
              ),
              borderRadius: BorderRadiusStyle.roundedBorder8,
            ),
            child: Container(
              height: 148.h,
              decoration: AppDecoration.outlineGray.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder8,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.h),
                        width: double.maxFinite,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    booklistItemModelObj.tf!,
                                    style: CustomTextStyles.bodySmall10,
                                  ),
                                  SizedBox(height: 8.h),
                                  SizedBox(
                                    width: 152.h,
                                    child: Text(
                                      booklistItemModelObj.tf1!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: CustomTextStyles
                                          .bodyMediumBlack90001
                                          .copyWith(
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    booklistItemModelObj.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      height: 1.50,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "lbl_396".tr,
                                          style: CustomTextStyles
                                              .titleMediumBluegray90001,
                                        ),
                                        TextSpan(
                                          text: "lbl10".tr,
                                          style: CustomTextStyles
                                              .bodySmallBluegray90001,
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
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
                    ],
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