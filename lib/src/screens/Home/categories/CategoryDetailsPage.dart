import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/BookCardWidget.dart';
import 'Logic/categories_cubit.dart';
import 'Logic/categories_state.dart';

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
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoryBooksLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is CategoryBooksLoaded) {
          final books = state.books;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...books.map((book) => BookCardWidget(
                          author: book['Author']?['name'] ?? '',
                          title: book['title'] ?? '',
                          description: book['description'] ?? '',
                          imageUrl: book['cover'] ?? '',
                          isFavorite: book['is_favorite'] ?? false,
                          price: book['price'],
                          pricePoints: book['price_points'],
                          isFree: book['is_free'] ?? false,
                          onTap: () {
                            // Handle book tap
                            print('Book tapped: ${book['title']}');
                          },
                        )),
                  ],
                ),
              ),
            ],
          );
        }

        if (state is CategoriesError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
