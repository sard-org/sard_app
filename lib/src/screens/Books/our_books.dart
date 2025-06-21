import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';
import 'logic/books_cubit.dart';
import 'logic/books_state.dart';
import '../PlayerScreen/audio_book_player_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late BooksCubit booksCubit;

  @override
  void initState() {
    super.initState();
    booksCubit = context.read<BooksCubit>();
    // Fetch books only if not already loaded (cached)
    _loadBooks();
  }

  void _loadBooks() {
    // This will use cache if available, or fetch from API if needed
    booksCubit.fetchBooks();
  }

  Future<void> _refreshBooks() async {
    // Force refresh from API
    await booksCubit.refreshBooks();
  }

  Widget _buildEmptyBooks() {
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
            "لم تقم بشراء كتب بعد",
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            "ابدأ رحلتك القرائية الآن.",
            style: AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
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
                SizedBox(height: 80),
                Expanded(
                  child: BlocBuilder<BooksCubit, BooksState>(
                    builder: (context, state) {
                      if (state is BooksLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primary700,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'جاري تحميل مكتبتك...',
                                style: AppTexts.contentBold.copyWith(
                                  color: AppColors.neutral700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else if (state is BooksLoaded) {
                        if (state.books.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: _refreshBooks,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height - 200,
                                child: _buildEmptyBooks(),
                              ),
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _refreshBooks,
                          color: AppColors.primary500,
                          backgroundColor: Colors.white,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: state.books.length,
                            itemBuilder: (context, index) {
                              final book = state.books[index];
                              return BookItem(
                                author: book.author,
                                title: book.title,
                                description: book.description,
                                imageUrl: book.imageUrl,
                                orderId: book.orderId,
                                bookId: book.id,
                                onTap: () {
                                  // الانتقال إلى AudioBookPlayer مع orderId
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AudioBookPlayer(
                                        bookId: book.id,
                                        orderId: book.orderId,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else if (state is BooksError) {
                        return RefreshIndicator(
                          onRefresh: _refreshBooks,
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
                                              text: 'كتبك',
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
                                        onPressed: () {
                                          booksCubit.fetchBooks(forceRefresh: true);
                                        },
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
                                          "إعادة المحاولة",
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
                      }
                      return RefreshIndicator(
                        onRefresh: _refreshBooks,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 200,
                            child: SizedBox(),
                          ),
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
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  "كتبي",
                  style: AppTexts.heading2Bold.copyWith(
                    color: AppColors.neutral100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String author;
  final String title;
  final String description;
  final String imageUrl;
  final String orderId;
  final String bookId;
  final VoidCallback? onTap;

  const BookItem({
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.orderId,
    required this.bookId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity, // تأكيد أن الكارد يأخذ العرض الكامل
          height: 200, // تحديث الارتفاع ليتناسب مع التصميم الجديد
          margin: EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.5, color: AppColors.neutral600), // تغيير إلى neutral600
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02), // تخفيف الشادو من 0.05 إلى 0.02
                blurRadius: 4, // تقليل الـ blur من 8 إلى 4
                offset: Offset(0, 1), // تقليل الـ offset من 2 إلى 1
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 120, // زيادة العرض أكثر
                height: 160, // زيادة الارتفاع
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: imageUrl.startsWith('http')
                        ? NetworkImage(imageUrl) as ImageProvider
                        : AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                        author,
                        textAlign: TextAlign.start,
                        style: AppTexts.captionRegular.copyWith(
                            color: AppColors.neutral500
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                        title,
                        textAlign: TextAlign.start,
                        style: AppTexts.contentAccent.copyWith(
                            color: AppColors.neutral900,
                            fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        description.isNotEmpty ? description : 'لا يوجد وصف متاح',
                        textAlign: TextAlign.start,
                        style: AppTexts.captionEmphasis.copyWith( // تغيير إلى captionEmphasis
                            color: AppColors.neutral500,
                            height: 1.5,
                        ),
                        maxLines: 4, // تحديد عدد أسطر معقول
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}