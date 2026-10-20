import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/change_baggage_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/join_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

import '../../../../modules/profile/controller/profile_data_controller.dart';
import '../../../../modules/ride&booking/model/enum/status.dart';
import '../../model/rider.dart';

class SearchRideCardController {
  SearchRideCardController({required this.ride}){
    final String currentUserId = Get.find<ProfileDataController>().userProfile.value?.id ?? "";
    for(final rider in ride.participants){
      riders.add(rider);
    }
    joinRideController = JoinRideController(ride: ride, onJoinSuccess: (newRiders) {
      riders.addAll(newRiders);
    },);
    changeBaggageController = ChangeBaggageController(bookingId: ride.id, onBaggageChangeSuccess: (changedBaggage) {
      for(int i = 0; i < riders.length; i++) {
        if(riders[i].userId == currentUserId) {
          riders[i] = riders[i].copyWith(baggageType: changedBaggage);
        }
      }
      riders.refresh();
    },); 
  }

  final RideModel ride;

  bool get eligibleToJoin => joinRideController.eligibleToJoin;
  bool get eligibleForChat => ride.status == Status.active;
  bool eligibleToFinish = false;
  bool eligibleForRatingRide = false;
  RxList<Rider> riders = RxList([]);

  ProcessStatusNotifier joinRideStn = ProcessStatusNotifier(initialStatus: EnabledStatus());
  late final JoinRideController joinRideController;
  late final ChangeBaggageController changeBaggageController;

  // Future<void> joinRide({
  //   required SnackbarNotifier? snackbarNotifier,
  //   required BaggageType baggageType
  // }) async{
  //   await joinRideController.joinRide(snackbarNotifier: snackbarNotifier);
  // }

}


