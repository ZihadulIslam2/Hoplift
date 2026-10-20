import 'package:flutter/material.dart';

import '../../../../modules/ride&booking/controller/leave_ride_controller.dart';
import '../../../notifiers/snackbar_notifier.dart';
import 'confirm_action_bottomsheet.dart';

Future<void> leaveRideBottomSheet({
  required BuildContext context,
  required LeaveRideController leaveRideController,

}) async {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return ConfirmActionBottomSheet(
          message: 'Are you sure you want to leave the ride?',
          confirmButtonText: 'Leave',
          cancelButtonText: 'Not Now',
          onConfirm: () async{
            
              leaveRideController
                  .leaveRide(
                    snackbarNotifier: SnackbarNotifier(
                      context: context,
                    ),
                  )
                  .then((_) {
              if(context.mounted) Navigator.pop(context);
            });
            // Add leave logic here
          },
          confirmStn: leaveRideController.stn,
        );
      },
    );
  
}
