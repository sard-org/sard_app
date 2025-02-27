part of 'iphone_14_fortysix_bloc.dart';

/// Represents the state of Iphone14Fortysix in the application.

// ignore_for_file: must_be_immutable
class Iphone14FortysixState extends Equatable {
  Iphone14FortysixState({this.iphone14FortysixModelObj});

  Iphone14FortysixModel? iphone14FortysixModelObj;

  @override
  List<Object?> get props => [iphone14FortysixModelObj];
  Iphone14FortysixState copyWith(
      {Iphone14FortysixModel? iphone14FortysixModelObj}) {
    return Iphone14FortysixState(
      iphone14FortysixModelObj:
          iphone14FortysixModelObj ?? this.iphone14FortysixModelObj,
    );
  }
}

