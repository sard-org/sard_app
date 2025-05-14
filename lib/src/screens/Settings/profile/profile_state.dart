import 'package:equatable/equatable.dart';
import 'package:sard/src/models/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final UserModel user;

  const ProfileUpdateSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError(this.message);

  @override
  List<Object?> get props => [message];
} 