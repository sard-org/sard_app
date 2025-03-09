import 'package:flutter/material.dart';
import '../../../style/Colors.dart';
import 'Fonts.dart';

class UpdateButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const UpdateButton({required this.title, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(title,

        style: AppTexts.contentEmphasis.copyWith(
          color: AppColors.neutral100,
        ),
      ),
    );
  }
}
