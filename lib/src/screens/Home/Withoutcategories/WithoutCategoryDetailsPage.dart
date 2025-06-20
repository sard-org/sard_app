import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../AudioBook/audio_book.dart';
import '../widgets/BookCardWidget.dart';
import 'ExchangeBookCard.dart';
import 'data/recommendations_api_service.dart';
import 'data/exchange_books_api_service.dart';
import 'all_recommended_books_screen.dart';
import 'all_exchange_books_screen.dart';

class WithoutCategoryDetailsPage extends StatefulWidget {
  const WithoutCategoryDetailsPage({Key? key}) : super(key: key);

  @override
  State<WithoutCategoryDetailsPage> createState() =>
      _WithoutCategoryDetailsPageState();
}

class _WithoutCategoryDetailsPageState
    extends State<WithoutCategoryDetailsPage> {
  final RecommendationsApiService _recommendationsApiService =
      RecommendationsApiService();
  final ExchangeBooksApiService _exchangeBooksApiService =
      ExchangeBooksApiService();

  List<Map<String, dynamic>> recommendedBooks = [];
  List<Map<String, dynamic>> exchangeBooks = [];

  bool isLoadingRecommendations = true;
  bool isLoadingExchangeBooks = true;

  String? recommendationsErrorMessage;
  String? exchangeBooksErrorMessage;
  @override
  void initState() {
    super.initState();
    _loadRecommendations();
    _loadExchangeBooks();
  }

  Future<void> _loadRecommendations() async {
    try {
      setState(() {
        isLoadingRecommendations = true;
        recommendationsErrorMessage = null;
      });

      final recommendations =
          await _recommendationsApiService.getRecommendations(limit: 4);
      setState(() {
        recommendedBooks = recommendations
            .map((book) => {
                  'id': book.id,
                  'author': book.author.name,
                  'title': book.title,
                  'description': book.description,
                  'imageUrl': book.cover,
                  'isFavorite': book.isFavorite,
                  'price': book.price,
                  'isFree': book.price == 0,
                })
            .toList();
        isLoadingRecommendations = false;
      });

      // Update global favorite status
      if (mounted) {
        context
            .read<GlobalFavoriteCubit>()
            .updateFavoriteStatusFromBooks(recommendedBooks);
      }
    } catch (e) {
      setState(() {
        recommendationsErrorMessage = e.toString();
        isLoadingRecommendations = false;
      });
    }
  }

  Future<void> _loadExchangeBooks() async {
    try {
      setState(() {
        isLoadingExchangeBooks = true;
        exchangeBooksErrorMessage = null;
      });

      final exchangeBooksData =
          await _exchangeBooksApiService.getExchangeBooks(limit: 3);
      setState(() {
        exchangeBooks = exchangeBooksData
            .map((book) => {
                  'id': book.id,
                  'author': book.author.name,
                  'title': book.title,
                  'coverUrl': book.cover,
                  'pricePoints': book.pricePoints,
                  'isFavorite': book.isFavorite,
                })
            .toList();
        isLoadingExchangeBooks = false;
      });

      // Update global favorite status
      if (mounted) {
        context
            .read<GlobalFavoriteCubit>()
            .updateFavoriteStatusFromBooks(exchangeBooks);
      }
    } catch (e) {
      setState(() {
        exchangeBooksErrorMessage = e.toString();
        isLoadingExchangeBooks = false;
      });
    }
  }

  void _updateLocalFavoriteStatus(String bookId, bool isFavorite) {
    setState(() {
      // Update recommended books
      for (int i = 0; i < recommendedBooks.length; i++) {
        if (recommendedBooks[i]['id'] == bookId) {
          recommendedBooks[i]['isFavorite'] = isFavorite;
          break;
        }
      }

      // Update exchange books
      for (int i = 0; i < exchangeBooks.length; i++) {
        if (exchangeBooks[i]['id'] == bookId) {
          exchangeBooks[i]['isFavorite'] = isFavorite;
          break;
        }
      }
    });
  }

  Widget _buildSectionHeader(String title, int count, VoidCallback onViewMore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTexts.heading1Bold.copyWith(
            fontSize: 24,
            color: AppColors.neutral900,
          ),
        ),
        TextButton(
          onPressed: onViewMore,
          child: Text(
            'شاهد المزيد',
            style: AppTexts.contentRegular.copyWith(
              color: AppColors.primary600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalFavoriteCubit, GlobalFavoriteState>(
      listener: (context, state) {
        if (state is GlobalFavoriteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في تحديث المفضلات: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is GlobalFavoriteUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.isFavorite
                  ? 'تم إضافة الكتاب إلى المفضلات'
                  : 'تم إزالة الكتاب من المفضلات'),
              backgroundColor: Colors.green,
            ),
          );

          // Update local state to reflect the change
          _updateLocalFavoriteStatus(state.bookId, state.isFavorite);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('كتب مرشحة لك', recommendedBooks.length,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllRecommendedBooksScreen(),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                if (isLoadingRecommendations)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (recommendationsErrorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'حدث خطأ في تحميل الكتب المقترحة',
                            style: AppTexts.contentRegular.copyWith(
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _loadRecommendations,
                            child: Text(
                              'إعادة المحاولة',
                              style: AppTexts.contentRegular.copyWith(
                                color: AppColors.primary600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (recommendedBooks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'لا توجد كتب مقترحة حالياً',
                        style: AppTexts.contentRegular.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedBooks.length,
                      itemBuilder: (context, index) {
                        var book = recommendedBooks[index];
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.75, // تصغير إلى 75% لإظهار جزء من الكارد التالي
                          margin: EdgeInsets.only(
                            right: index == 0 ? 0 : 16, // إزالة المسافة من اليمين للكارد الأول
                            left: index == recommendedBooks.length - 1 ? 16 : 0,
                          ),
                          child: BookCardWidget(
                            id: book['id'].toString(),
                            author: book['author'] as String,
                            title: book['title'] as String,
                            description: book['description'] as String,
                            imageUrl: book['imageUrl'] as String,
                            is_favorite: book['isFavorite'] as bool,
                            price: book['price'] as int?,
                            pricePoints: book['pricePoints'] as int?,
                            isFree: book['isFree'] as bool,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AudioBookScreen(
                                      bookId: book['id'] as String),
                                ),
                              );
                            },
                            onFavoriteTap: () {
                              final globalFavoriteCubit =
                                  context.read<GlobalFavoriteCubit>();
                              globalFavoriteCubit
                                  .toggleFavorite(book['id'].toString());
                            },
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),
                _buildSectionHeader('استبدل نقاطك', exchangeBooks.length, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllExchangeBooksScreen(),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                if (isLoadingExchangeBooks)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (exchangeBooksErrorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'حدث خطأ في تحميل كتب التبديل',
                            style: AppTexts.contentRegular.copyWith(
                              color: AppColors.neutral900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _loadExchangeBooks,
                            child: Text(
                              'إعادة المحاولة',
                              style: AppTexts.contentRegular.copyWith(
                                color: AppColors.primary600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (exchangeBooks.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'لا توجد كتب للتبديل حالياً',
                        style: AppTexts.contentRegular.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ),
                  )
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: exchangeBooks.asMap().entries.map((entry) {
                        int index = entry.key;
                        var book = entry.value;
                        return Container(
                          margin: EdgeInsets.only(
                            right: index == 0 ? 0 : 12, // إزالة المسافة من اليمين للكارد الأول
                            left: index == exchangeBooks.length - 1 ? 16 : 0,
                          ),
                          child: ExchangeBookCard(
                          id: book['id'] as String,
                          title: book['title'] as String,
                          author: book['author'] as String,
                          coverUrl: book['coverUrl'] as String,
                          pricePoints: book['pricePoints'] as int,
                          isFavorite: book['isFavorite'] as bool,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AudioBookScreen(
                                    bookId: book['id'] as String),
                              ),
                            );
                          },
                          onFavoriteTap: () {
                            final globalFavoriteCubit =
                                context.read<GlobalFavoriteCubit>();
                            globalFavoriteCubit
                                .toggleFavorite(book['id'].toString());
                          },
                        ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
