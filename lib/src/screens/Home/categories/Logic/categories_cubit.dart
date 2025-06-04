import 'package:flutter_bloc/flutter_bloc.dart';
import '../Data/categories_dio.dart';
import '../Data/categories_model.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesDio _categoriesDio;

  CategoriesCubit(this._categoriesDio) : super(CategoriesInitial());

  void fetchCategories() async {
    emit(CategoriesLoading());
    try {
      final data = await _categoriesDio.getCategories();
      final categories = data.map((e) => CategoryModel.fromJson(e)).toList();
      emit(CategoriesLoaded(List<CategoryModel>.from(categories)));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
