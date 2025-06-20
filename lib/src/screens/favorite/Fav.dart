import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'data/dio_Fav.dart';
import 'logic/favorite_cubit.dart';
import 'logic/favorite_state.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';
import '../AudioBook/audio_book.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoriteCubit? cubit;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initCubit();
  }

  Future<void> _initCubit() async {
    try {
      setState(() {
        isInitializing = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      
      if (token.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('يرجى تسجيل الدخول أولاً'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final favCubit = FavoriteCubit(
        dioFav: DioFav(),
        token: token,
      );
      
      if (mounted) {
        setState(() {
          cubit = favCubit;
          isInitializing = false;
        });
        cubit?.getFavorites();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isInitializing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حدث خطأ في تحميل المفضلات'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    cubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Stack(
        children: [
          if (isInitializing || cubit == null)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
              ),
            )
          else
            BlocProvider.value(
              value: cubit!,
              child: BaseScreen(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Expanded(
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          if (state is FavoriteLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
                              ),
                            );
                          } else if (state is FavoriteErrorState) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: AppColors.primary600,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'حدث خطأ في تحميل المفضلات',
                                    style: AppTexts.heading3Bold.copyWith(
                                      color: AppColors.neutral800,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    state.message,
                                    style: AppTexts.contentRegular.copyWith(
                                      color: AppColors.neutral500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: () => cubit?.getFavorites(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary500,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text(
                                      'إعادة المحاولة',
                                      style: AppTexts.highlightAccent.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is FavoriteSuccessState) {
                            final books = state.favorites;
                            if (books.isEmpty) return _buildEmptyFavorites();
                            return ListView.builder(
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                final book = books[index];
                                final String? bookId = book['id']?.toString();
                                if (bookId == null) return const SizedBox.shrink();

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AudioBookScreen(
                                          bookId: bookId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: BookItem(
                                    author: book["Author"]?["name"]?.toString() ?? 'مؤلف غير معروف',
                                    title: book["title"]?.toString() ?? 'عنوان غير معروف',
                                    description: book["description"]?.toString() ?? '',
                                    price: "",
                                    currency: "",
                                    imageUrl: book["cover"]?.toString() ?? 'assets/img/Book_1.png',
                                    onFavoritePressed: () => cubit?.removeFavorite(bookId),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "المفضلات",
                  style: AppTexts.heading2Bold.copyWith(color: AppColors.neutral100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/img/fav_embty.png",
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 16),
          Text(
            "القائمة فارغة",
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            " أضف كتبًا إلى المفضلة لتكون دائمًا في متناولك",
            style:
                AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatefulWidget {
  final String author;
  final String title;
  final String description;
  final String price;
  final String currency;
  final String imageUrl;
  final VoidCallback onFavoritePressed;

  const BookItem({
    required this.author,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.onFavoritePressed,
  });

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool isFavorite = true;
  double size = 1.0;

  void toggleFavorite() {
    setState(() {
      isFavorite = false;
      size = 1.2;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => size = 1.0);
      widget.onFavoritePressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(size),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: const Color(0xFFFCFEF5),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: AppColors.primary900),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 93,
              height: 125,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2, color: Color(0xFF2B2B2B)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.author,
                      style: AppTexts.captionRegular
                          .copyWith(color: AppColors.neutral400)),
                  const SizedBox(height: 8),
                  Text(widget.title,
                      style: AppTexts.highlightStandard
                          .copyWith(color: AppColors.neutral1000)),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: AppTexts.contentRegular
                        .copyWith(color: AppColors.neutral400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.price,
                        style: AppTexts.highlightAccent
                            .copyWith(color: AppColors.primary1000),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        widget.currency,
                        style: AppTexts.footnoteRegular11
                            .copyWith(color: AppColors.primary1000),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite,
                  color: isFavorite ? Colors.red : AppColors.primary900),
              onPressed: toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
