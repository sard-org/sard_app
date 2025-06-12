import 'package:flutter/material.dart';
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
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
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
          const SizedBox(height: 16),
          Text(
            'لا توجد كتب للتبديل حالياً',
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BaseScreen(
            child: Column(
              children: [
                const SizedBox(height: 80),
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
                                      horizontal: 16, vertical: 16),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.6,
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
                                                AudioBookScreen(),
                                          ),
                                        );
                                      },
                                      onFavoriteTap: () {
                                        print(
                                            'Favorite tapped for: ${book.title}');
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'استبدل نقاطك',
                      style: AppTexts.heading1Bold.copyWith(
                        color: AppColors.neutral900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
