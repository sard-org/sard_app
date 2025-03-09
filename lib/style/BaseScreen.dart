import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const BaseScreen({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(20.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تعيين لون الخلفية إلى الأخضر
      body: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

