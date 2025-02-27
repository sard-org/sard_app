import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/congratulation_profile_light_version_model.dart';

part 'congratulation_profile_light_version_event.dart';
part 'congratulation_profile_light_version_state.dart';

/// A bloc that manages the state of a CongratulationProfileLightVersion
/// according to the event that is dispatched to it.
class CongratulationProfileLightVersionBloc extends Bloc<
    CongratulationProfileLightVersionEvent, CongratulationProfileLightVersionState> {
  
  CongratulationProfileLightVersionBloc()
      : super(CongratulationProfileLightVersionState()) {
    on<CongratulationProfileLightVersionInitialEvent>(_onInitialize);
  }

  Future<void> _onInitialize(
    CongratulationProfileLightVersionInitialEvent event,
    Emitter<CongratulationProfileLightVersionState> emit,
  ) async {
    // TODO: أضف المنطق المطلوب هنا
  }
}
