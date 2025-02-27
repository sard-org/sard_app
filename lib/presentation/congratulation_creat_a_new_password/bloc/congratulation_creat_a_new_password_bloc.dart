import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

part 'congratulation_create_a_new_password_event.dart';
part 'congratulation_create_a_new_password_state.dart';

/// A bloc that manages the state of a CongratulationCreateANewPassword 
/// according to the event that is dispatched to it.
class CongratulationCreateNewPasswordBloc extends Bloc<
    CongratulationCreateNewPasswordEvent,
    CongratulationCreateNewPasswordState> {
  
  CongratulationCreateNewPasswordBloc(
      CongratulationCreateNewPasswordState initialState)
      : super(initialState) {
    on<CongratulationCreateNewPasswordInitialEvent>(_onInitialize);
  }

  Future<void> _onInitialize(
    CongratulationCreateNewPasswordInitialEvent event,
    Emitter<CongratulationCreateNewPasswordState> emit,
  ) async {
    // قم بإضافة أي منطق مطلوب هنا عند تهيئة البلوك
  }
}
