import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/kickout_rider_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/leave_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/booking.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';
import '../../../../modules/profile/controller/profile_data_controller.dart';
import '../../../../modules/ride&booking/controller/change_baggage_controller.dart';
import '../../../../modules/ride&booking/controller/finish_ride_controller.dart';
import '../../../../modules/ride&booking/controller/join_ride_controller.dart';
import '../../../../modules/ride&booking/model/enum/status.dart';
import '../../../notifiers/snackbar_notifier.dart';
import '../../model/rider.dart';

class BookedRideCardActionController {
  BookedRideCardActionController({required this.booking, required this.onLeaveSuccess, required this.onFinishRideSuccess}) {
    for(final rider in booking.ride.participants){
      riders.add(rider);
    }

    finishRideController = FinishRideController(ride: booking.ride, onFinishRideSuccess:()=> onFinishRideSuccess());
    leaveRideController = LeaveRideController(ride: booking.ride, onLeaveSuccess: ()=> onLeaveSuccess());
    joinRideController = JoinRideController(ride: booking.ride, onJoinSuccess: onJoinSuccess);
    changeBaggageController = ChangeBaggageController(bookingId: booking.id, onBaggageChangeSuccess: onBaggageChangeSuccess); 
    kickoutRiderController = KickoutRiderController(rideId: booking.ride.id, onKickSuccess: (){
      
    });
    // eligibility to finish, rate-ride
   
  }

  final Booking booking;
  final VoidCallback onLeaveSuccess;
  final VoidCallback onFinishRideSuccess;

  bool get eligibleForChat => booking.ride.status == Status.active && booking.ride.participants.where((rider) => rider.userId != Get.find<ProfileDataController>().userProfile.value?.id).isNotEmpty;
  bool get eligibleToJoin => joinRideController.eligibleToJoin;
  bool get eligibleToLeave => leaveRideController.eligibleToLeave;
  bool get eligibleToFinish => finishRideController.eligibleToFinish;
  
  RxList<Rider> riders = RxList([]);

  late ProcessStatusNotifier leaveStn = leaveRideController.stn;
  late ProcessStatusNotifier finishRideStn = finishRideController.stn;
  late final FinishRideController finishRideController;
  late final LeaveRideController leaveRideController;
  late final JoinRideController joinRideController;
  late final ChangeBaggageController changeBaggageController;
  late final KickoutRiderController kickoutRiderController;

  bool get eligibleForRatingRide => booking.ride.status == Status.completed;

  Future<void> leaveRide({
    required SnackbarNotifier? snackbarNotifier
  }) async{
    if(eligibleToLeave == false) return;
    return await leaveRideController.leaveRide(snackbarNotifier: snackbarNotifier);
  }

  Future<void> finishRide({
    required SnackbarNotifier? snackbarNotifier,
  }) async{
    await finishRideController.finishRide(snackbarNotifier: snackbarNotifier);
  }

  void onJoinSuccess(List<Rider> newRiders) {
    riders.addAll(newRiders);
  }

  void onBaggageChangeSuccess(BaggageType baggageType) {
    for(int i = 0; i < riders.length; i++) {
      if(riders[i].userId == Get.find<ProfileDataController>().userProfile.value?.id) {
        riders[i] = riders[i].copyWith(baggageType: baggageType);
      }
    }
    riders.refresh();
  }
}
