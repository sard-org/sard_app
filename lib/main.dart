import 'package:flutter/material.dart';
import 'package:sard/src/screens/Home/home.dart';
import 'package:sard/src/screens/books/our_books.dart';
import 'package:sard/style/Colors.dart';

import 'src/screens/Fav/Fav.dart';
import 'src/screens/settings/setting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    HomeScreen(), // الرئيسية
    BookListScreen(), // كتبي
    FavoritesScreen(), // المفضلات
    NotificationsScreen(), // الإشعارات
  ];

  List<String> iconPaths = [
    "assets/img/icons/home.png",
    "assets/img/icons/book.png",
    "assets/img/icons/Fav.png",
    "assets/img/icons/not.png"
  ];

  List<String> selectedIconPaths = [
    "assets/img/icons/home done.png",
    "assets/img/icons/book done.png",
    "assets/img/icons/Fav done.png",
    "assets/img/icons/Not done.png"
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.neutral400,
          items: List.generate(4, (index) {
            return BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == index ? selectedIconPaths[index] : iconPaths[index],
                width: 28,
                height: 28,
              ),
              label: ["الرئيسية", "كتبي", "المفضلات", "الإشعارات"][index],
            );
          }),
        ),
      ),
    );
  }
}
