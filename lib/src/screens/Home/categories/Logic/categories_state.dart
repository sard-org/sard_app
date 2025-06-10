import 'package:equatable/equatable.dart';
import '../Data/categories_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryBooksLoading extends CategoriesState {}

class CategoryBooksLoaded extends CategoriesState {
  final List<dynamic> books;

  const CategoryBooksLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object> get props => [message];
}
