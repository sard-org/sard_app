import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../services/favorite_service.dart';
import '../utils/error_translator.dart';

// States
abstract class GlobalFavoriteState extends Equatable {
  const GlobalFavoriteState();

  @override
  List<Object> get props => [];
}

class GlobalFavoriteInitial extends GlobalFavoriteState {}

class GlobalFavoriteLoading extends GlobalFavoriteState {}

class GlobalFavoriteUpdated extends GlobalFavoriteState {
  final String bookId;
  final bool isFavorite;

  const GlobalFavoriteUpdated({
    required this.bookId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [bookId, isFavorite];
}

class GlobalFavoriteError extends GlobalFavoriteState {
  final String message;

  const GlobalFavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class GlobalFavoriteCubit extends Cubit<GlobalFavoriteState> {
  final FavoriteService _favoriteService;
  final Set<String> _favoriteBookIds = <String>{};

  GlobalFavoriteCubit({FavoriteService? favoriteService})
      : _favoriteService = favoriteService ?? FavoriteService(),
        super(GlobalFavoriteInitial());

  Set<String> get favoriteBookIds => Set.unmodifiable(_favoriteBookIds);

  bool isFavorite(String bookId) {
    return _favoriteBookIds.contains(bookId);
  }

  Future<void> toggleFavorite(String bookId) async {
    final currentlyFavorite = _favoriteBookIds.contains(bookId);

    try {
      emit(GlobalFavoriteLoading());

      await _favoriteService.toggleFavorite(bookId, currentlyFavorite);

      if (currentlyFavorite) {
        _favoriteBookIds.remove(bookId);
      } else {
        _favoriteBookIds.add(bookId);
      }

      emit(GlobalFavoriteUpdated(
        bookId: bookId,
        isFavorite: !currentlyFavorite,
      ));
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(GlobalFavoriteError(userFriendlyError));
    }
  }

  void updateFavoriteStatus(String bookId, bool isFavorite) {
    if (isFavorite) {
      _favoriteBookIds.add(bookId);
    } else {
      _favoriteBookIds.remove(bookId);
    }
  }

  void updateFavoriteStatusFromBooks(List<Map<String, dynamic>> books) {
    for (var book in books) {
      final bookId = book['id']?.toString();
      final isFavorite = book['isFavorite'] as bool? ?? false;
      if (bookId != null) {
        updateFavoriteStatus(bookId, isFavorite);
      }
    }
  }

  Future<void> loadFavorites() async {
    try {
      final favorites = await _favoriteService.getFavorites();
      _favoriteBookIds.clear();
      for (var book in favorites) {
        if (book['id'] != null) {
          _favoriteBookIds.add(book['id'].toString());
        }
      }
    } catch (e) {
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(GlobalFavoriteError(userFriendlyError));
    }
  }
}
