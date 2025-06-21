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
  FavoriteCubit? _favoriteCubit;

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
  }

  void _initializeFavorites() {
    try {
      // Try to get the cubit from the global providers
      _favoriteCubit = context.read<FavoriteCubit>();
      // Load favorites (will use cache if available)
      _favoriteCubit?.getFavorites();
    } catch (e) {
      // If global cubit is not available, create a local one
      _initLocalCubit();
    }
  }

  Future<void> _initLocalCubit() async {
    try {
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
              backgroundColor: AppColors.red100,
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
          _favoriteCubit = favCubit;
        });
        _favoriteCubit?.getFavorites();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('حدث خطأ في تحميل المفضلات'),
            ),
            backgroundColor: AppColors.red100,
          ),
        );
      }
    }
  }

  Future<void> _refreshFavorites() async {
    await _favoriteCubit?.refreshFavorites();
  }

  @override
  void dispose() {
    // Only dispose if it's a local cubit, not global
    if (_favoriteCubit != context.read<FavoriteCubit?>()) {
      _favoriteCubit?.close();
    }
    super.dispose();
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
            "لا توجد كتب مفضلة",
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            "ابدأ بإضافة الكتب التي تحبها إلى مفضلتك",
            style: AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_favoriteCubit == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل مفضلتك...',
                    style: AppTexts.contentBold.copyWith(
                      color: AppColors.neutral700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            BlocProvider.value(
              value: _favoriteCubit!,
              child: BaseScreen(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Expanded(
                      child: BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          if (state is FavoriteLoadingState) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'جاري تحميل مفضلتك...',
                                    style: AppTexts.contentBold.copyWith(
                                      color: AppColors.neutral700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          } else if (state is FavoriteErrorState) {
                            return RefreshIndicator(
                              onRefresh: _refreshFavorites,
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: MediaQuery.of(context).size.height - 200,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 80,
                                            color: AppColors.primary600,
                                          ),
                                          SizedBox(height: 24),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              text: 'عذراً، حدث خطأ أثناء تحميل ',
                                              style: AppTexts.heading2Bold.copyWith(
                                                color: AppColors.neutral700,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'مفضلتك',
                                                  style: AppTexts.heading2Bold.copyWith(
                                                    color: AppColors.red200,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary100,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.primary200,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              state.message,
                                              style: AppTexts.contentRegular.copyWith(
                                                color: AppColors.neutral700,
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          ElevatedButton(
                                            onPressed: () => _favoriteCubit?.getFavorites(forceRefresh: true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary500,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'إعادة المحاولة',
                                              style: AppTexts.contentBold.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else if (state is FavoriteSuccessState) {
                            final books = state.favorites;
                            if (books.isEmpty) {
                              return RefreshIndicator(
                                onRefresh: _refreshFavorites,
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height - 200,
                                    child: _buildEmptyFavorites(),
                                  ),
                                ),
                              );
                            }
                            
                            return RefreshIndicator(
                              onRefresh: _refreshFavorites,
                              color: AppColors.primary500,
                              backgroundColor: Colors.white,
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
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
                                      onFavoritePressed: () => _favoriteCubit?.removeFavorite(bookId),
                                    ),
                                  );
                                },
                              ),
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
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: AppColors.neutral300),
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
                child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 120,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.author,
                            style: AppTexts.captionRegular
                                .copyWith(color: AppColors.neutral500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.title,
                            style: AppTexts.contentBold
                                .copyWith(
                                  color: AppColors.neutral900,
                                  fontSize: 16,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (widget.description.isNotEmpty)
                            Expanded(
                              child: Text(
                                widget.description,
                                style: AppTexts.captionRegular
                                    .copyWith(
                                      color: AppColors.neutral600,
                                      height: 1.4,
                                    ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
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
              Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: Icon(
                      Icons.favorite,
                      color: isFavorite ? Colors.red : AppColors.neutral500,
                      size: 28,
                    ),
                    onPressed: toggleFavorite,
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
