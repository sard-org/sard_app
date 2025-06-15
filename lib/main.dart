import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/Home/home.dart';
import 'package:sard/src/screens/PlayerScreen/audio_book_player_screen.dart';
import 'package:sard/src/screens/auth/login/data/dio_login_helper.dart';
import 'package:sard/src/screens/auth/login/logic/login_cubit.dart';
import 'package:sard/src/screens/books/our_books.dart';
import 'package:sard/src/screens/favorite/Fav.dart';
import 'package:sard/src/screens/settings/setting.dart';
import 'package:sard/src/cubit/global_favorite_cubit.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/bloc_observar.dart';

void main() {
  DioHelper.init();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
          ),
          BlocProvider<GlobalFavoriteCubit>(
            create: (context) => GlobalFavoriteCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AudioBookPlayer(), //  البداية من شاشة الـ .
        ));
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // ✅ تعيين `HomeScreen` كأول شاشة افتراضية
  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();

  List<Widget> get _screens => [
        HomeScreen(key: _homeScreenKey), // ✅ الرئيسية أولًا
        BookListScreen(), // كتبي
        FavoritesScreen(), // المفضلات
        SettingsScreen(), // الإعدادات
      ];

  List<String> iconPaths = [
    "assets/img/icons/home.png",
    "assets/img/icons/book.png",
    "assets/img/icons/Fav.png",
    "assets/img/icons/Not.png"
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
              if (index == 0) {
                // Reset category selection when home is tapped
                _homeScreenKey.currentState?.resetCategorySelection();
              }
              _currentIndex = index;
            });
          },
          selectedItemColor: AppColors.primary500,
          unselectedItemColor: AppColors.neutral400,
          items: List.generate(4, (index) {
            return BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == index
                    ? selectedIconPaths[index]
                    : iconPaths[index],
                width: 28,
                height: 28,
              ),
              label: ["الرئيسية", "كتبي", "المفضلات", "الإعدادات"][index],
            );
          }),
        ),
      ),
    );
  }
}
