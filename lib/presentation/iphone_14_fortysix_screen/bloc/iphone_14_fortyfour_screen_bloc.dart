import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/iphone_14_fortysix_model.dart';
part 'iphone_14_fortysix_event.dart';
part 'iphone_14_fortysix_state.dart';

/// A bloc that manages the state of a Iphone14Fortysix according to the event that is dispatched to it.
class Iphone14FortysixBloc
    extends Bloc<Iphone14FortysixEvent, Iphone14FortysixState> {
  Iphone14FortysixBloc(Iphone14FortysixState initialState)
      : super(initialState) {
    on<Iphone14FortysixInitialEvent>(_onInitialize);
  }

  _onInitialize(
    Iphone14FortysixInitialEvent event,
    Emitter<Iphone14FortysixState> emit,
  ) async {}
}

