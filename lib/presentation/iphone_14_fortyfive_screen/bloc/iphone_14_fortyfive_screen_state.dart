part of 'iphone_14_fortyfive_bloc.dart';

/// Represents the state of Iphone14Fortyfive in the application.

// ignore_for_file: must_be_immutable
class Iphone14FortyfiveState extends Equatable {
  Iphone14FortyfiveState({this.iphone14FortyfiveModelObj});

  Iphone14FortyfiveModel? iphone14FortyfiveModelObj;

  @override
  List<Object?> get props => [iphone14FortyfiveModelObj];
  Iphone14FortyfiveState copyWith(
      {Iphone14FortyfiveModel? iphone14FortyfiveModelObj}) {
    return Iphone14FortyfiveState(
      iphone14FortyfiveModelObj:
          iphone14FortyfiveModelObj ?? this.iphone14FortyfiveModelObj,
    );
  }
}

