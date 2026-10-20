import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/handle_fold.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/profile_data_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/ride_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/rate_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

import '../../../core/common/model/rider.dart';
import '../model/rating.dart';

class RateRideController {
  final RideModel ride;
  final ProcessStatusNotifier stn = ProcessStatusNotifier(initialStatus: EnabledStatus());

  RateRideController({required this.ride}){
    final currentUserId = Get.find<ProfileDataController>().userProfile.value?.id ?? "";
    for(final rider in ride.participants) {
      if(!_riderRatings.containsKey(rider.userId) && rider.userId != currentUserId) {
        riders.add(rider);
        _riderRatings[rider.userId] = rider.avgRating.toDouble();
      }
    }
  }

  List<Rider> riders = [];

  Map<String, double> _riderRatings = {};

  void rateRider(String riderId, double rating) {
    _riderRatings[riderId] = rating;
  }

  Future<void> submitRatings({SnackbarNotifier? snackbarNotifier}) async {
    stn.setLoading();
    await serviceLocator<RideInterface>()
      .rateRide(
        param: RateRideReqParam(
          rideId: ride.id,
          ratings: _riderRatings.entries
              .map((e) => Rating(userId: e.key, score: e.value))
              .toList(),
        ),
      )
      .then((lr) {
        handleFold(
          either: lr,
          processStatusNotifier: stn,
          successSnackbarNotifier: snackbarNotifier,
          errorSnackbarNotifier: snackbarNotifier,
          onSuccess: (data) {
            stn.setEnabled();
          },
        );
      });
  }

}