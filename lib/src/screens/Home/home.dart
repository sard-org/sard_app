import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تحديد لون الخلفية للأبيض
      body: Center(
        child: Text(
          '1',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

