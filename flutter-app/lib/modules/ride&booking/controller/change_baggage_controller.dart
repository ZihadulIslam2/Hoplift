import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/ride_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/change_baggage_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';

import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/join_ride_req_param.dart';

class ChangeBaggageController {
  ChangeBaggageController({required this.bookingId, required this.onBaggageChangeSuccess});
  
  final ProcessStatusNotifier stn = ProcessStatusNotifier(initialStatus: EnabledStatus());
  Rx<BaggageType> baggageType = Rx<BaggageType>(BaggageType.small);
  final String bookingId;
  final void Function(BaggageType changedBaggage) onBaggageChangeSuccess;

  Future<void> changeBaggage({
    required SnackbarNotifier? snackbarNotifier,
    required String riderId,
  }) async{
    if(baggageType.value == null){
      return;
    }
    stn.setLoading();
    await serviceLocator<RideInterface>().changeBaggage(
      ChangeBaggageReqParam(rideId: bookingId, baggageType: baggageType.value!, bookingId: riderId,)
    ).then((lr){
      handleFold(
        either: lr,
        processStatusNotifier: stn,
        successSnackbarNotifier: snackbarNotifier,
        onSuccess: (data) {
          data.toString();
          onBaggageChangeSuccess(baggageType.value!);
        },
      );
      Future.delayed(const Duration(seconds: 1)).then((_) {
        stn.setEnabled();
      });
    });
  }
}