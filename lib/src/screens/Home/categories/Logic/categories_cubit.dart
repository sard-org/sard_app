import 'package:flutter_bloc/flutter_bloc.dart';

import '../Data/categories_dio.dart';
import 'categories_state.dart';
import '../../../../utils/error_translator.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesService _categoriesService;

  CategoriesCubit(this._categoriesService) : super(CategoriesInitial());

  Future<void> getCategories() async {
    try {
      emit(CategoriesLoading());
      final categories = await _categoriesService.getCategories();
      emit(CategoriesLoaded(categories.categories));
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(CategoriesError(userFriendlyError));
    }
  }

  // Future<void> getCategoryBooks(String category_id) async {
  //   try {
  //     emit(CategoryBooksLoading());
  //     final books = await _categoriesService.getCategoryBooks(category_id);
  //     emit(CategoryBooksLoaded(books));
  //   } catch (e) {
  //     emit(CategoriesError(e.toString()));
  //   }
  // }
  Future<void> getCategoryBooks(String categoryId) async {
    try {
      emit(CategoryBooksLoading());
      final books = await _categoriesService.getCategoryBooks(categoryId);
      emit(CategoryBooksLoaded(books));
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(CategoriesError(userFriendlyError));
    }
  }
}
