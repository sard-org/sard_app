import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/iphone_14_fortythree_model.dart';
part 'iphone_14_fortythree_event.dart';
part 'iphone_14_fortythree_state.dart';

/// A bloc that manages the state of a Iphone14Fortythree according to the event that is dispatched to it.
class Iphone14FortythreeBloc
    extends Bloc<Iphone14FortythreeEvent, Iphone14FortythreeState> {
  Iphone14FortythreeBloc(Iphone14FortythreeState initialState)
      : super(initialState) {
    on<Iphone14FortythreeInitialEvent>(_onInitialize);
  }

  _onInitialize(
    Iphone14FortythreeInitialEvent event,
    Emitter<Iphone14FortythreeState> emit,
  ) async {}
}

