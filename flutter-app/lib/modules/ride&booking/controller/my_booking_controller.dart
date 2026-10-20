import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/pagination.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../model/get_my_bookings_req_param.dart';
import '../../../core/common/components/booked_ride_card/booked_ride_card_controller.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../app/init_dependency.dart';
import '../interface/booking_interface.dart';
import '../model/enum/status.dart';

class MyBookingControllers {
  BookingController active = BookingController(Status.active);
  BookingController completed = BookingController(Status.completed);
}


class BookingController extends GetxController{
  BookingController(this.bookingsType);
  /// Active or, Completed
  final Status bookingsType;
  RxString errorMessage = ''.obs;
  Rx<Pagination<BookedRideCardActionController>> paginatedbookedRideControllers = Rx<Pagination<BookedRideCardActionController>>(NotInitialized([]));

  int _page = 0;

  _onLeaveSuccess() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      getBookings();
    });
  }

  _onFinishRideSuccess() {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      getBookings();
    });
  }

  Future<void> getBookings({
    SnackbarNotifier? snackbarNotifier,
    bool forceRefresh = false
  }) async{
    if(forceRefresh) {
      paginatedbookedRideControllers.value = RefreshingPage<BookedRideCardActionController>([]);
    }
    paginatedbookedRideControllers.value = RefreshingPage<BookedRideCardActionController>([]);
    if(_page > 1) {
      snackbarNotifier?.notifySuccess(message:  "Refreshing bookings...".tr());
    }
    await serviceLocator<BookingInterface>().getMyBookings(bookingsType == Status.completed ? GetMyBookingsReqParam.completed() : GetMyBookingsReqParam.active()).then((lr) {
      handleFold(
        either: lr,
        onSuccess: (data) {
          List<BookedRideCardActionController> bookedControllers = [];
          for (var element in data) {
            if(element.status == bookingsType) {
              bookedControllers.add(
                BookedRideCardActionController(booking: element, onLeaveSuccess: _onLeaveSuccess, onFinishRideSuccess: _onFinishRideSuccess, )
              );
            }
          }
          bookedControllers.sort((a, b) => b.booking.ride.departureTime.compareTo(a.booking.ride.departureTime));
          paginatedbookedRideControllers.value = Loaded([... paginatedbookedRideControllers.value.data + bookedControllers]);
        },
        onError: (message) {
          errorMessage.value = message.uiMessage;
        },
      );
    });
    update();
  }
}


// class CompleteBookingController extends BookingController {
//   CompleteBookingController(this.snackbarNotifier);

//   final SnackbarNotifier? snackbarNotifier;

//   @override
//   Future<void> getBookings({SnackbarNotifier? snackbarNotifier, bool forceRefresh = false}) async{
//     if(forceRefresh) {
//       bookings.clear();
//       paginatedbookedRideControllers.value = RefreshingPage<BookedRideCardActionController>([]);
//       _page = 0;
//       _isLoading = false;
//     }
//     if(_isLoading) return;
//     _isLoading = true;
//     bookings.clear();
//     paginatedbookedRideControllers.value = RefreshingPage<BookedRideCardActionController>([]);
//     _page += 1;
//     update();
//     if(_page > 1) {
//       snackbarNotifier?.notifySuccess(message:  "Refreshing bookings...".tr());
//     }
//     //await Future.delayed(const Duration(seconds: 1));
//     await serviceLocator<BookingInterface>().getMyBookings(GetMyBookingsReqParam.active()).then((lr) {
//       handleFold(
//         either: lr,
//         onSuccess: (data) {
//           for (var element in data) {
//             if(element.status == Status.completed) {
//               bookings.add(
//                 BookedRideCardActionController(booking: element, onLeaveSuccess: _onLeaveSuccess, onFinishRideSuccess: _onFinishRideSuccess)
//               );
//             }
//           }
//           bookings.sort((a, b) => b.booking.ride.departureTime.compareTo(a.booking.ride.departureTime));
//           bookings.refresh();
//           paginatedbookedRideControllers = List.generate(data.length, (index) => BookedRideCardActionController(
//             booking: data[index],
//             onFinishRideSuccess: _onFinishRideSuccess,
//             onLeaveSuccess: _onLeaveSuccess,
//           )).obs;
          
//         },
//         onError: (message) {
//           errorMessage.value = message.uiMessage;
//         },
//       );
//     });
//     _isLoading = false;
//     update();
//   }
  
// }
