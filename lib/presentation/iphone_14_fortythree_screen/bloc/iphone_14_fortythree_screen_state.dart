part of 'iphone_14_fortythree_bloc.dart';

/// Represents the state of Iphone14Fortythree in the application.

// ignore_for_file: must_be_immutable
class Iphone14FortythreeState extends Equatable {
  Iphone14FortythreeState({this.iphone14FortythreeModelObj});

  Iphone14FortythreeModel? iphone14FortythreeModelObj;

  @override
  List<Object?> get props => [iphone14FortythreeModelObj];
  Iphone14FortythreeState copyWith(
      {Iphone14FortythreeModel? iphone14FortythreeModelObj}) {
    return Iphone14FortythreeState(
      iphone14FortythreeModelObj:
          iphone14FortythreeModelObj ?? this.iphone14FortythreeModelObj,
    );
  }
}

