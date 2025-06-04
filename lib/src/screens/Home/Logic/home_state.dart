import '../Data/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModelhome user;

  HomeLoaded(this.user);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
