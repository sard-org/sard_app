import 'package:equatable/equatable.dart';

/// This class is used in the [loginlight_tab_page] screen.

// ignore_for_file: must_be_immutable
class LoginlightTabModel extends Equatable {
  LoginlightTabModel({this.booklistItemList = const []});

  List<BooklistItemModel> booklistItemList;

  LoginlightTabModel copyWith({List<BooklistItemModel>? booklistItemList}) {
    return LoginlightTabModel(
      booklistItemList: booklistItemList ?? this.booklistItemList,
    );
  }

  @override
  List<Object?> get props => [booklistItemList];
}

