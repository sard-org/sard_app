import 'package:flutter/material.dart';

import 'Colors.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BaseScreen({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.only(top: 24.0, left: 18.0, right: 18.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100, // تعيين لون الخلفية إلى الأخضر
      body: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

