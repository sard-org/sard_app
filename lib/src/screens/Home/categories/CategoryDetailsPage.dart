import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../widgets/BookCardWidget.dart';
import 'Logic/categories_cubit.dart';
import 'Logic/categories_state.dart';
import '../../AudioBook/audio_book.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String id;

  const CategoryDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().getCategoryBooks(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoryBooksLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary700,
              ),
            );
          }
          
          if (state is CategoryBooksLoaded) {
            final books = state.books;
            
            if (books.isEmpty) {
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
                      'لا توجد كتب في هذه الفئة',
                      style: AppTexts.contentRegular.copyWith(
                        color: AppColors.neutral600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final bookData = books[index] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BookCardWidget(
                    author: bookData['Author']?['name'] ?? '',
                    title: bookData['title'] ?? '',
                    description: bookData['description'] ?? '',
                    imageUrl: bookData['cover'] ?? 'assets/images/book_placeholder.png',
                    is_favorite: bookData['is_favorite'] ?? false,
                    price: bookData['price'],
                    pricePoints: bookData['price_points'],
                    isFree: bookData['is_free'] ?? false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioBookScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          if (state is CategoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.red200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ في تحميل الكتب',
                    style: AppTexts.contentRegular.copyWith(
                      color: AppColors.neutral600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTexts.contentRegular.copyWith(
                      color: AppColors.neutral500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary700,
            ),
          );
        },
      ),
    );
  }
}
