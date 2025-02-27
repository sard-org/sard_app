import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/iphone_14_fortyfour_model.dart';
part 'iphone_14_fortyfour_event.dart';
part 'iphone_14_fortyfour_state.dart';

/// A bloc that manages the state of a Iphone14Fortyfour according to the event that is dispatched to it.
class Iphone14FortyfourBloc
    extends Bloc<Iphone14FortyfourEvent, Iphone14FortyfourState> {
  Iphone14FortyfourBloc(Iphone14FortyfourState initialState)
      : super(initialState) {
    on<Iphone14FortyfourInitialEvent>(_onInitialize);
  }

  _onInitialize(
    Iphone14FortyfourInitialEvent event,
    Emitter<Iphone14FortyfourState> emit,
  ) async {}
}

