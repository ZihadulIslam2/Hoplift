


// showModalBottomSheet(
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         builder: (context) {
//           return ConfirmActionBottomSheet(
//             message: 'Are you sure you want to vote to kick out ${rider.name}',
//             confirmButtonText: 'Kick Out',
//             cancelButtonText: 'Not Now',
//             onConfirm: () async{
//               await widget.kickoutRiderController?.kickRider(riderId: rider.userId, snackbarNotifier: SnackbarNotifier(context: context)).then((_) {
//                 if(context.mounted) Navigator.pop(context);
//               });
//             },
//             onCancel: () {
//               // Add cancel logic here
//               Navigator.pop(context);
//             },
//             confirmStn: widget.kickoutRiderController!.stn,
//           );
//         },
//       );

import 'package:flutter/material.dart';

import 'confirm_action_bottomsheet.dart';
import '../../../../modules/ride&booking/controller/kickout_rider_controller.dart';
import '../../../notifiers/snackbar_notifier.dart';
import '../../model/rider.dart';

Future<void> showOtherRiderLongPressOptions({
  required BuildContext context,
  required Rider rider,
  required KickoutRiderController kickoutRiderController
}) async{
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return ConfirmActionBottomSheet(
        message: 'Are you sure you want to kick out ${rider.name}',
        confirmButtonText: 'Kick Out',
        cancelButtonText: 'Not Now',
        onConfirm: () async{
          await kickoutRiderController.kickRider(riderId: rider.userId, snackbarNotifier: SnackbarNotifier(context: context)).then((_) {
            if(context.mounted) Navigator.pop(context);
          });
        },
        confirmStn: kickoutRiderController.stn,
      );
    },
  );
}