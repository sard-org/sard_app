import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/Splash/Splash.dart';
import 'package:sard/style/Colors.dart';
import 'package:sard/style/Fonts.dart';
import 'package:sard/style/BaseScreen.dart';

import 'package:sard/src/screens/Books/book_model.dart';

import '../AudioBook/audio_book.dart';
import '../PlayerScreen/audio_book_player_screen.dart';
import 'logic/books_cubit.dart';
import 'logic/books_state.dart';

class BookListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BooksCubit()..fetchBooks(),
      child: Scaffold(
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
                          return Center(child: CircularProgressIndicator(
                            color: AppColors.primary700,
                          ));
                        } else if (state is BooksLoaded) {
                          if (state.books.isEmpty) {
                            return Center(
                              child: Text(
                                "لا توجد كتب متاحة حالياً",
                                style: AppTexts.contentRegular.copyWith(
                                  color: AppColors.neutral700,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: state.books.length,
                            itemBuilder: (context, index) {
                              final book = state.books[index];
                              return BookItem(
                                author: book.author,
                                title: book.title,
                                description: book.description,
                                imageUrl: book.imageUrl,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AudioBookPlayer(),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is BooksError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: AppTexts.contentRegular.copyWith(
                                    color: AppColors.primary700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<BooksCubit>().fetchBooks();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary500,
                                  ),
                                  child: Text(
                                    "إعادة المحاولة",
                                    style: AppTexts.heading1Bold.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox();
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
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String author;
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const BookItem({
    required this.author,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: Color(0xFFFCFEF5),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.50, color: AppColors.primary900),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 93,
                height: 125,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: imageUrl.startsWith('http')
                        ? NetworkImage(imageUrl) as ImageProvider
                        : AssetImage(imageUrl),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 2, color: Color(0xFF2B2B2B)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        author,
                        textAlign: TextAlign.start,
                        style: AppTexts.captionRegular.copyWith(
                            color: AppColors.neutral400
                        )
                    ),
                    SizedBox(height: 4),
                    Text(
                        title,
                        textAlign: TextAlign.start,
                        style: AppTexts.highlightStandard.copyWith(
                            color: AppColors.neutral1000
                        )
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.start,
                      style: AppTexts.contentRegular.copyWith(
                          color: AppColors.neutral400
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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