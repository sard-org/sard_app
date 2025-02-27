part of 'iphone_14_fortyfour_bloc.dart';

/// Represents the state of Iphone14Fortyfour in the application.

// ignore_for_file: must_be_immutable
class Iphone14FortyfourState extends Equatable {
  Iphone14FortyfourState({this.iphone14FortyfourModelObj});

  Iphone14FortyfourModel? iphone14FortyfourModelObj;

  @override
  List<Object?> get props => [iphone14FortyfourModelObj];
  Iphone14FortyfourState copyWith(
      {Iphone14FortyfourModel? iphone14FortyfourModelObj}) {
    return Iphone14FortyfourState(
      iphone14FortyfourModelObj:
          iphone14FortyfourModelObj ?? this.iphone14FortyfourModelObj,
    );
  }
}

