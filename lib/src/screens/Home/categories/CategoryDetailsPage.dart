import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../AudioBook/audio_book.dart';
import '../widgets/BookCardWidget.dart';
import 'Logic/categories_cubit.dart';
import 'Logic/categories_state.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String id;

  const CategoryDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    context.read<CategoriesCubit>().getCategoryBooks(id);
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      buildWhen: (previous, current) =>
          current is CategoryBooksLoaded || current is CategoryBooksLoading,
      builder: (context, state) {
        if (state is CategoryBooksLoaded) {
          final books = state.books;
          print("this here");

          // Update global favorite state with current book favorite status
          final globalFavoriteCubit = context.read<GlobalFavoriteCubit>();
          for (var bookData in books) {
            final bookId = bookData['id']?.toString();
            final isFavorite = bookData['is_favorite'] as bool? ?? false;
            if (bookId != null) {
              globalFavoriteCubit.updateFavoriteStatus(bookId, isFavorite);
            }
          }

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
                  const SizedBox(height: 8),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: books.length,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final bookData = books[index] as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BookCardWidget(
                  id: bookData['id'] ?? '',
                  author: bookData['Author']?['name'] ?? '',
                  title: bookData['title'] ?? '',
                  description: bookData['description'] ?? '',
                  imageUrl:
                      bookData['cover'] ?? 'assets/images/book_placeholder.png',
                  is_favorite: bookData['is_favorite'] ?? false,
                  price: bookData['price'],
                  pricePoints: bookData['price_points'],
                  isFree: bookData['is_free'] ?? false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AudioBookScreen(bookId: bookData['id'] ?? ''),
                      ),
                    );
                  },
                  onFavoriteTap: () {
                    final globalFavoriteCubit =
                        context.read<GlobalFavoriteCubit>();
                    globalFavoriteCubit.toggleFavorite(bookData['id'] ?? '');
                  },
                ),
              );
            },
          );
        }

        return Container(
          height: 200,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary500,
            ),
          ),
        );
      },
    );
  }
}
