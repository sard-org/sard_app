import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../AudioBook/audio_book.dart';
import '../widgets/BookCardWidget.dart';
import 'ExchangeBookCard.dart';
import '../Logic/home_books_cubit.dart';
import '../Logic/home_books_state.dart';
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
  List<Map<String, dynamic>> recommendedBooks = [];
  List<Map<String, dynamic>> exchangeBooks = [];

  @override
  void initState() {
    super.initState();
    // Load data using cache with delay to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🚀 WithoutCategoryDetailsPage: Loading home books');
      context.read<HomeBooksLCubit>().loadRecommendedBooks(limit: 4);
      context.read<HomeBooksLCubit>().loadExchangeBooks(limit: 3);
    });
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
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
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'شاهد المزيد',
              style: AppTexts.contentRegular.copyWith(
                color: AppColors.primary600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GlobalFavoriteCubit, GlobalFavoriteState>(
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
                  backgroundColor: AppColors.green200,
                ),
              );

              // Update local state to reflect the change
              _updateLocalFavoriteStatus(state.bookId, state.isFavorite);
            }
          },
        ),
        BlocListener<HomeBooksLCubit, HomeBooksState>(
          listener: (context, state) {
            print('🎯 BlocListener received state: ${state.runtimeType}');
            if (state is RecommendedBooksLoaded) {
              print('📚 Recommended books loaded: ${state.books.length} books');
              setState(() {
                recommendedBooks = state.books
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
              });
              print('📚 Updated recommendedBooks list: ${recommendedBooks.length} items');

              // Update global favorite status
              context
                  .read<GlobalFavoriteCubit>()
                  .updateFavoriteStatusFromBooks(recommendedBooks);
            } else if (state is ExchangeBooksLoaded) {
              print('💰 Exchange books loaded: ${state.books.length} books');
              setState(() {
                exchangeBooks = state.books
                    .map((book) => {
                          'id': book.id,
                          'author': book.author.name,
                          'title': book.title,
                          'coverUrl': book.cover,
                          'pricePoints': book.pricePoints,
                          'isFavorite': book.isFavorite,
                        })
                    .toList();
              });
              print('💰 Updated exchangeBooks list: ${exchangeBooks.length} items');

              // Update global favorite status
              context
                  .read<GlobalFavoriteCubit>()
                  .updateFavoriteStatusFromBooks(exchangeBooks);
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Column(
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
              BlocBuilder<HomeBooksLCubit, HomeBooksState>(
                buildWhen: (previous, current) =>
                    current is RecommendedBooksLoading ||
                    current is RecommendedBooksLoaded ||
                    current is RecommendedBooksError,
                builder: (context, state) {
                  print('🏗️ Recommended books builder - state: ${state.runtimeType}, books count: ${recommendedBooks.length}');
                  if (state is RecommendedBooksLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is RecommendedBooksError) {
                    return Center(
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
                              onPressed: () => context
                                  .read<HomeBooksLCubit>()
                                  .loadRecommendedBooks(
                                      forceRefresh: true, limit: 4),
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
                    );
                  } else if (recommendedBooks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendedBooks.length,
                        itemBuilder: (context, index) {
                          var book = recommendedBooks[index];
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            margin: EdgeInsets.only(
                              right: index == 0 ? 0 : 16,
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
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              _buildSectionHeader('استبدل نقاطك', exchangeBooks.length, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllExchangeBooksScreen(),
                  ),
                );
              }),
              const SizedBox(height: 12),
              BlocBuilder<HomeBooksLCubit, HomeBooksState>(
                buildWhen: (previous, current) =>
                    current is ExchangeBooksLoading ||
                    current is ExchangeBooksLoaded ||
                    current is ExchangeBooksError,
                builder: (context, state) {
                  print('🏗️ Exchange books builder - state: ${state.runtimeType}, books count: ${exchangeBooks.length}');
                  if (state is ExchangeBooksLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is ExchangeBooksError) {
                    return Center(
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
                              onPressed: () => context
                                  .read<HomeBooksLCubit>()
                                  .loadExchangeBooks(
                                      forceRefresh: true, limit: 3),
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
                    );
                  } else if (exchangeBooks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: exchangeBooks.asMap().entries.map((entry) {
                          int index = entry.key;
                          var book = entry.value;
                          return Container(
                            margin: EdgeInsets.only(
                              right: index == 0 ? 0 : 12,
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
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
