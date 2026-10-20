import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../../../app/init_dependency.dart';
import '../interface/ride_interface.dart';

class LeaveRideController {
  LeaveRideController({required this.ride, required this.onLeaveSuccess});
  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  final RideModel ride;
  final VoidCallback onLeaveSuccess;
  final ProcessStatusNotifier stn = ProcessStatusNotifier(initialStatus: EnabledStatus());
  bool get eligibleToLeave => ride.departureTime.isAfter(DateTime.now());

  /// Use stn to listen to thje state changes...
  Future<void> leaveRide({
    SnackbarNotifier? snackbarNotifier,
  }) async{
    stn.setLoading();
    _debouncer.call(() async{
      await serviceLocator<RideInterface>().leaveRide(rideId: ride.id).then((lr){
        handleFold(
          either: lr,
          processStatusNotifier: stn,
          successSnackbarNotifier: snackbarNotifier,
          errorSnackbarNotifier: snackbarNotifier,
          onSuccess: (data) {
            onLeaveSuccess();
          },
        );
      });
    });
    
  }
}

