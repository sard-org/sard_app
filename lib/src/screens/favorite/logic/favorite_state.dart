abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteSuccessState extends FavoriteState {
  final List<dynamic> favorites;
  FavoriteSuccessState(this.favorites);
}

class FavoriteErrorState extends FavoriteState {
  final String message;
  FavoriteErrorState(this.message);
}
