import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/vote_for_kick_req_param.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../../../app/init_dependency.dart';
import '../interface/ride_interface.dart';

class KickoutRiderController {
  KickoutRiderController({required this.rideId, required this.onKickSuccess});
  final String rideId;
  final VoidCallback onKickSuccess;
  final ProcessStatusNotifier stn = ProcessStatusNotifier(initialStatus: EnabledStatus());

  /// Make sure you have the [stn] to use the state changes.
  Future<void> kickRider({
    required String riderId,
    SnackbarNotifier? snackbarNotifier,
  }) async{
    await serviceLocator<RideInterface>().voteForKick(
      param: VoteForKickReqParam(rideId, riderId)).then((lr){
      handleFold(
        either: lr,
        processStatusNotifier: stn,
        errorSnackbarNotifier: snackbarNotifier,
        successSnackbarNotifier: snackbarNotifier,
        onSuccess: (data) {
          onKickSuccess();
        },
        onError: (failure) {
          // Get.showSnackbar(
          //   GetSnackBar(
          //     title: "Error",
          //     message: failure.uiMessage,
          //     backgroundColor: Colors.red,
          // ));
        },
      );

      Future.delayed(const Duration(seconds: 1)).then((_) {
        stn.setEnabled();
      });
    });
  }
}

