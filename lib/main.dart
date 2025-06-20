import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:sard/src/screens/Home/home.dart';
import 'package:sard/src/screens/Splash/Splash.dart';
import 'package:sard/src/screens/auth/login/data/dio_login_helper.dart';
import 'package:sard/src/screens/auth/login/logic/login_cubit.dart';
import 'package:sard/src/screens/Books/our_books.dart';
import 'package:sard/src/screens/favorite/Fav.dart';
import 'package:sard/src/screens/settings/setting.dart';
import 'package:sard/src/cubit/global_favorite_cubit.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/bloc_observar.dart';
import 'src/screens/Books/logic/books_cubit.dart';
import 'src/screens/favorite/logic/favorite_cubit.dart';
import 'src/screens/favorite/data/dio_Fav.dart';
import 'src/screens/Home/Logic/home_cubit.dart';
import 'src/screens/Home/categories/Logic/categories_cubit.dart';
import 'src/screens/Home/categories/Data/categories_dio.dart';
import 'src/screens/Home/Logic/home_books_cubit.dart';
import 'src/screens/Home/Withoutcategories/data/recommendations_api_service.dart';
import 'src/screens/Home/Withoutcategories/data/exchange_books_api_service.dart';

void main() {
  DioHelper.init();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getAuthToken(),
      builder: (context, snapshot) {
        // Show loading while checking token
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final authToken = snapshot.data ?? '';

        return MultiBlocProvider(
          providers: [
            // Auth cubit (required for login/logout functionality)
            BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
            ),
            // Global favorite cubit
            BlocProvider<GlobalFavoriteCubit>(
              create: (context) => GlobalFavoriteCubit(),
            ),
            // Home cubit (user data)
            BlocProvider<HomeCubit>(
              create: (context) => HomeCubit(),
            ),
            // Categories cubit
            BlocProvider<CategoriesCubit>(
              create: (context) => CategoriesCubit(
                CategoriesService(Dio()..options.baseUrl = 'https://api.mohamed-ramadan.me/api/'),
              ),
            ),
            // Home Books cubit (recommended & exchange books)
            BlocProvider<HomeBooksLCubit>(
              create: (context) => HomeBooksLCubit(
                recommendationsService: RecommendationsApiService(),
                exchangeBooksService: ExchangeBooksApiService(),
              ),
            ),
            // Books cubit
            BlocProvider<BooksCubit>(
              create: (context) => BooksCubit(),
            ),
            // Favorites cubit (only if token exists)
            if (authToken.isNotEmpty)
              BlocProvider<FavoriteCubit>(
                create: (context) => FavoriteCubit(
                  dioFav: DioFav(),
                  token: authToken,
                ),
              ),
          ],
          child: MaterialApp(
            title: 'SARD',
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        );
      },
    );
  }

  Future<String?> _getAuthToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);
  
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // Use the provided initial index
  }

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
          backgroundColor: Colors.white,
          elevation: 8.0,
          items: List.generate(4, (index) {
            return BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Image.asset(
                  _currentIndex == index
                      ? selectedIconPaths[index]
                      : iconPaths[index],
                  width: 28,
                  height: 28,
                ),
              ),
              label: ["الرئيسية", "كتبي", "المفضلات", "الإعدادات"][index],
            );
          }),
        ),
      ),
    );
  }
}
