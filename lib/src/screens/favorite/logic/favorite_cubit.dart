import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/dio_Fav.dart';
import 'favorite_state.dart';
import '../../../utils/error_translator.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final DioFav dioFav;
  final String token;

  FavoriteCubit({required this.dioFav, required this.token}) : super(FavoriteInitial());

  Future<void> getFavorites() async {
    emit(FavoriteLoadingState());
    try {
      final data = await dioFav.getFavorites(token);
      emit(FavoriteSuccessState(data));
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(FavoriteErrorState(userFriendlyError));
    }
  }

  Future<void> addFavorite(String id) async {
    try {
      await dioFav.addToFavorite(token, id);
      await getFavorites();
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(FavoriteErrorState(userFriendlyError));
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await dioFav.removeFromFavorite(token, id);
      await getFavorites();
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(FavoriteErrorState(userFriendlyError));
    }
  }
}
