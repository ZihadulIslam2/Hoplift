import 'dart:ui';

import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../../../app/init_dependency.dart';
import '../interface/ride_interface.dart';

class FinishRideController {
  FinishRideController({required this.ride, required this.onFinishRideSuccess});
  final RideModel ride;
  final VoidCallback onFinishRideSuccess;

  final ProcessStatusNotifier stn = ProcessStatusNotifier(initialStatus: EnabledStatus());

  bool get eligibleToFinish => ride.departureTime.isBefore(DateTime.now());
  Future<void> finishRide({
    required SnackbarNotifier? snackbarNotifier,
  }) async{
    await serviceLocator<RideInterface>().finishRide(rideId: ride.id).then((lr){
      handleFold(
        either: lr,
        processStatusNotifier: stn,
        successSnackbarNotifier: snackbarNotifier,
        errorSnackbarNotifier: snackbarNotifier,
        onSuccess: (data) {
          onFinishRideSuccess();
        },
      );
      Future.delayed(const Duration(seconds: 1)).then((_) {
        stn.setEnabled();
      });
    });
  }
}