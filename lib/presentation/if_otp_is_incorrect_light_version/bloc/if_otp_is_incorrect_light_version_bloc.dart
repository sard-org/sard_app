import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/if_otp_is_incorrect_light_version_model.dart';
part 'if_otp_is_incorrect_light_version_event.dart';
part 'if_otp_is_incorrect_light_version_state.dart';

/// A bloc that manages the state of a IfOtpIsIncorrectLightVersion according to the event that is dispatched to it.
class IfOtpIsIncorrectLightVersionBloc extends Bloc<
    IfOtpIsIncorrectLightVersionEvent, IfOtpIsIncorrectLightVersionState> {
  IfOtpIsIncorrectLightVersionBloc(
      IfOtpIsIncorrectLightVersionState initialState)
      : super(initialState) {
    on<IfOtpIsIncorrectLightVersionInitialEvent>(_onInitialize);
  }

  _onInitialize(
    IfOtpIsIncorrectLightVersionInitialEvent event,
    Emitter<IfOtpIsIncorrectLightVersionState> emit,
  ) async {}
}

