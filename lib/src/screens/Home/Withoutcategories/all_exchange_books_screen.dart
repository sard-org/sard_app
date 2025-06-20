import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../../../style/BaseScreen.dart';
import '../../AudioBook/audio_book.dart';
import 'ExchangeBookCard.dart';
import 'data/exchange_books_api_service.dart';
import 'data/exchange_books_model.dart';

class AllExchangeBooksScreen extends StatefulWidget {
  const AllExchangeBooksScreen({Key? key}) : super(key: key);

  @override
  State<AllExchangeBooksScreen> createState() => _AllExchangeBooksScreenState();
}

class _AllExchangeBooksScreenState extends State<AllExchangeBooksScreen> {
  final ExchangeBooksApiService _apiService = ExchangeBooksApiService();
  List<ExchangeBook> exchangeBooks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllExchangeBooks();
  }

  Future<void> _loadAllExchangeBooks() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get all books without limit
      final books = await _apiService.getExchangeBooks();
      setState(() {
        exchangeBooks = books;
        isLoading = false;
      });

      // Update global favorite status
      if (mounted) {
        final booksData = books
            .map((book) => {
                  'id': book.id,
                  'isFavorite': book.isFavorite,
                })
            .toList();
        context
            .read<GlobalFavoriteCubit>()
            .updateFavoriteStatusFromBooks(booksData);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _updateLocalFavoriteStatus(String bookId, bool isFavorite) {
    setState(() {
      for (int i = 0; i < exchangeBooks.length; i++) {
        if (exchangeBooks[i].id == bookId) {
          // Since we can't modify the ExchangeBook object directly, we need to replace it
          // For now, we'll just trigger a rebuild which will use the global state
          break;
        }
      }
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swap_horiz,
            size: 64,
            color: AppColors.neutral400,
          ),

          const SizedBox(height: 8),
          Text(
            "اجمع النقاط لتتمكن من تبديلها بالكتب",
            style:
                AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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
            'حدث خطأ في تحميل الكتب',
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'خطأ غير معروف',
            style:
                AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadAllExchangeBooks,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'إعادة المحاولة',
              style: AppTexts.contentBold.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.primary500),
            ),
          ),
          SizedBox(width: 12),
          Text(
            "استبدل نقاطك",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<GlobalFavoriteCubit, GlobalFavoriteState>(
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

            // Update local state
            _updateLocalFavoriteStatus(state.bookId, state.isFavorite);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              BaseScreen(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary700,
                              ),
                            )
                          : errorMessage != null
                              ? _buildErrorState()
                              : exchangeBooks.isEmpty
                                  ? _buildEmptyState()
                                  : GridView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.54, // تعديل النسبة لتتناسب مع الارتفاع الثابت
                                      ),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: exchangeBooks.length,
                                      itemBuilder: (context, index) {
                                        final book = exchangeBooks[index];
                                        return ExchangeBookCard(
                                          id: book.id,
                                          title: book.title,
                                          author: book.author.name,
                                          coverUrl: book.cover,
                                          pricePoints: book.pricePoints,
                                          isFavorite: book.isFavorite,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioBookScreen(
                                                        bookId: book.id),
                                              ),
                                            );
                                          },
                                          onFavoriteTap: () {
                                            final globalFavoriteCubit = context
                                                .read<GlobalFavoriteCubit>();
                                            globalFavoriteCubit
                                                .toggleFavorite(book.id);
                                          },
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildAppBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
