import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/iphone_14_fortyfive_model.dart';
part 'iphone_14_fortyfive_event.dart';
part 'iphone_14_fortyfive_state.dart';

/// A bloc that manages the state of a Iphone14Fortyfive according to the event that is dispatched to it.
class Iphone14FortyfiveBloc
    extends Bloc<Iphone14FortyfiveEvent, Iphone14FortyfiveState> {
  Iphone14FortyfiveBloc(Iphone14FortyfiveState initialState)
      : super(initialState) {
    on<Iphone14FortyfiveInitialEvent>(_onInitialize);
  }

  _onInitialize(
    Iphone14FortyfiveInitialEvent event,
    Emitter<Iphone14FortyfiveState> emit,
  ) async {}
}

