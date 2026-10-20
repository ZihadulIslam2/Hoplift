import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/bottomsheets/leave_ride_bottom_sheet.dart';

import 'confirm_action_bottomsheet.dart';
import '../../../../modules/ride&booking/controller/change_baggage_controller.dart';
import '../../../../modules/ride&booking/controller/kickout_rider_controller.dart';
import '../../../../modules/ride&booking/controller/leave_ride_controller.dart';
import '../../../notifiers/snackbar_notifier.dart';
import 'change_baggage_bottom_sheet.dart';

Future<void> showOwnRiderLongPressOptions({
  required BuildContext context,
  required Rider rider,
  LeaveRideController? leaveRideController,
  ChangeBaggageController? changeBaggageController,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return RiderLongPressOptions(leaveRideController: leaveRideController, changeBaggageController: changeBaggageController, rider: rider);
    },
  );
}

class RiderLongPressOptions extends StatefulWidget {
  final Rider rider;
  final LeaveRideController? leaveRideController;
  final ChangeBaggageController? changeBaggageController;
  const RiderLongPressOptions({super.key, this.leaveRideController, this.changeBaggageController, required this.rider});

  @override
  State<RiderLongPressOptions> createState() => _RiderLongPressOptionsState();
}

class _RiderLongPressOptionsState extends State<RiderLongPressOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Opacity(
                opacity: (widget.leaveRideController?.eligibleToLeave ?? false) ? 1 : 0.5,
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Leave Ride'),
                  onTap: () {
                    if(widget.leaveRideController == null) return;
                    Navigator.pop(context);
                    if(widget.leaveRideController == null) {
                      return;
                    }
                    leaveRideBottomSheet(context: context, leaveRideController: widget.leaveRideController!);
                  },
                ),
              ),
              if(widget.changeBaggageController != null) Opacity(
                opacity: (widget.changeBaggageController != null) ? 1 : 0.5,
                child: ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('Change Baggage'),
                  onTap: (widget.changeBaggageController == null) ? null : () async {
                    Navigator.pop(context);
                    if(widget.changeBaggageController == null) return;
                    await showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return ChangeBaggageBottomSheet(
                          changeBaggageController: widget.changeBaggageController!,
                          riderId: widget.rider.userId,
                          initialBaggageType: widget.rider.baggageType,
                        );
                      },
                    );
                  },
                ),
              ),
              
              SizedBox(height: 50),
            ],
          );
        
  }
}