import 'package:equatable/equatable.dart';
import '../Withoutcategories/data/recommendations_model.dart';
import '../Withoutcategories/data/exchange_books_model.dart';

abstract class HomeBooksState extends Equatable {
  const HomeBooksState();

  @override
  List<Object> get props => [];
}

class HomeBooksInitial extends HomeBooksState {}

class HomeBooksLoading extends HomeBooksState {}

class HomeBooksAllLoaded extends HomeBooksState {}

class HomeBooksError extends HomeBooksState {
  final String message;

  const HomeBooksError(this.message);

  @override
  List<Object> get props => [message];
}

// Recommended Books States
class RecommendedBooksLoading extends HomeBooksState {}

class RecommendedBooksLoaded extends HomeBooksState {
  final List<RecommendedBook> books;

  const RecommendedBooksLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class RecommendedBooksError extends HomeBooksState {
  final String message;

  const RecommendedBooksError(this.message);

  @override
  List<Object> get props => [message];
}

// Exchange Books States
class ExchangeBooksLoading extends HomeBooksState {}

class ExchangeBooksLoaded extends HomeBooksState {
  final List<ExchangeBook> books;

  const ExchangeBooksLoaded(this.books);

  @override
  List<Object> get props => [books];
}

class ExchangeBooksError extends HomeBooksState {
  final String message;

  const ExchangeBooksError(this.message);

  @override
  List<Object> get props => [message];
} 