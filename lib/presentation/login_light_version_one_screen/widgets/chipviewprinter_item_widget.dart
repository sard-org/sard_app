import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/chipviewprinter_item_model.dart';

// ignore_for_file: must_be_immutable
class ChipviewprinterItemWidget extends StatelessWidget {
    ChipviewprinterItemWidget(
        this.chipviewprinterItemModelObj, {
        Key? key,
        this.onSelectedChipView,
    }) : super(key: key);

    ChipviewprinterItemModel chipviewprinterItemModelObj;
    Function(bool)? onSelectedChipView;

    @override
    Widget build(BuildContext context) {
        return Theme(
            data: ThemeData(
                canvasColor: Colors.transparent,
            ),
            child: RawChip(
                padding: EdgeInsets.only(
                    left: 16.h,
                    top: 14.h,
                    bottom: 14.h,
                ),
                showCheckmark: false,
                labelPadding: EdgeInsets.zero,
                label: Text(
                    chipviewprinterItemModelObj.printerTwo1,
                    style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 12.fSize,
                        fontFamily: 'Alexandria',
                        fontWeight: FontWeight.w400,
                    ),
                ),
                deleteIcon: CustomImageView(
                    imagePath: ImageConstant.imgPrinter,
                    height: 22.h,
                    width: 18.h,
                margin: EdgeInsets.only(left: 12.h),
                ),
                onDeleted: () {},
                selected: (chipviewprinterItemModelObj.isSelected ?? false),
                backgroundColor: Colors.transparent,
                selectedColor: Colors.transparent,
                shape: (chipviewprinterItemModelObj.isSelected ?? false)
                    ? RoundedRectangleBorder(
                        side: BorderSide(
                            color: appTheme.gray40002,
                            width: 1.h,
                        ),
                        borderRadius: BorderRadius.circular(8.h),
                    )
                    : RoundedRectangleBorder(
                        side: BorderSide(
                            color: appTheme.gray40002,
                            width: 1.h,
                        ),
                        borderRadius: BorderRadius.circular(8.h),
                    ),
                onSelected: (value) {
                    onSelectedChipView?.call(value);
                },
            ),
        );
    }
}