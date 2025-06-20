import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../../../style/BaseScreen.dart';
import '../../AudioBook/audio_book.dart';
import '../widgets/BookCardWidget.dart';
import 'data/recommendations_api_service.dart';
import 'data/recommendations_model.dart';

class AllRecommendedBooksScreen extends StatefulWidget {
  const AllRecommendedBooksScreen({Key? key}) : super(key: key);

  @override
  State<AllRecommendedBooksScreen> createState() =>
      _AllRecommendedBooksScreenState();
}

class _AllRecommendedBooksScreenState extends State<AllRecommendedBooksScreen> {
  final RecommendationsApiService _apiService = RecommendationsApiService();
  List<RecommendedBook> recommendedBooks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllRecommendedBooks();
  }

  Future<void> _loadAllRecommendedBooks() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get all books without limit
      final recommendations = await _apiService.getRecommendations();
      setState(() {
        recommendedBooks = recommendations;
        isLoading = false;
      });

      // Update global favorite status
      if (mounted) {
        final booksData = recommendations
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
      for (int i = 0; i < recommendedBooks.length; i++) {
        if (recommendedBooks[i].id == bookId) {
          // Since we can't modify the RecommendedBook object directly, we trigger a rebuild
          // The BlocBuilder in BookCardWidget will handle showing the correct state
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
            Icons.library_books_outlined,
            size: 64,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد كتب مقترحة حالياً',
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            "سنقوم بتحديث الكتب المقترحة قريباً",
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
            onPressed: _loadAllRecommendedBooks,
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
            "كتب مرشحة لك",
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
                backgroundColor: Colors.green,
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
                              : recommendedBooks.isEmpty
                                  ? _buildEmptyState()
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      itemCount: recommendedBooks.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final book = recommendedBooks[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: BookCardWidget(
                                            id: book.id,
                                            author: book.author.name,
                                            title: book.title,
                                            description: book.description,
                                            imageUrl: book.cover,
                                            is_favorite: book.isFavorite,
                                            price: book.price,
                                            pricePoints: null,
                                            isFree: book.price == 0,
                                            showDescription: true, // إظهار الوصف في هذه الصفحة
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
                                              final globalFavoriteCubit =
                                                  context.read<
                                                      GlobalFavoriteCubit>();
                                              globalFavoriteCubit
                                                  .toggleFavorite(book.id);
                                            },
                                          ),
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
