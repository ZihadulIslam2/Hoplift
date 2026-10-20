import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/debug/debug_service.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/ride_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/create_ride_req_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/view/create_ride_view.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../main.dart';

class CreateNewRideController extends GetxController{
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: EnabledStatus());
  LocationAdress? fromLocation;
  LocationAdress? toLocation;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  RxInt seatAvailable = RxInt(1);
  BaggageType selectedBaggageIndex = BaggageType.small;

  final List<String> baggageTypes = BaggageType.values.map((e) => e.name).toList();

  CreateNewRideController(CreateFromSearchInputParam? param) {
    if(param != null) {
      _initializeWithSearchParams(param);
      return;
    }
    _initializeDefaultValues();
  }

  Future<void> _initializeDefaultValues() async {
    final now = DateTime.now();
    selectedDate = now;
    selectedTime = TimeOfDay.fromDateTime(now);
    dateController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    timeController.text = selectedTime!.format(navigatorKey.currentContext!);
    seatAvailable.value = 1;
  }

  void _initializeWithSearchParams(CreateFromSearchInputParam param) {
    debugPrint("Initializing with search params, ${param.toString()}");
    fromLocation = param.fromLocation;
    fromController.text = fromLocation?.address ?? "";
    toLocation = param.toLocation;
    toController.text = param.toLocation?.address ?? "";
    selectedDate = param.selectedDate;
    selectedTime = param.selectedTime;
    dateController.text =
        "${param.selectedDate!.year}-${param.selectedDate!.month.toString().padLeft(2, '0')}-${param.selectedDate!.day.toString().padLeft(2, '0')}";
    timeController.text = param.selectedTime!.format(navigatorKey.currentContext!);
    seatAvailable.value = param.passengerCount;
  }

  Future<void> selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      selectedDate = picked;
      dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final initialTime = selectedTime ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      selectedTime = picked;
      if(context.mounted) timeController.text = picked.format(context);
    }
  }

  void incrementPassengers() {
    if(seatAvailable < 4) seatAvailable++;
  }

  void decrementPassengers() {
    if (seatAvailable > 1) seatAvailable--;
  }

  void resetForm(BuildContext context) async {
    processStatusNotifier.setEnabled();
    final now = DateTime.now();
    selectedDate = now;
    dateController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    selectedTime = TimeOfDay.fromDateTime(now);
    timeController.text = selectedTime!.format(context);
    seatAvailable.value = 1;
    selectedBaggageIndex = BaggageType.none;
    fromController.clear();
    toController.clear();
  }

  Future<bool> submitRide({
    SnackbarNotifier? snackbarNotifier,
  }) async {
    // Validate inputs
    if (fromLocation == null || toLocation == null) {
      snackbarNotifier?.notify(message: 'Please fill in both locations'.tr());
      return false;
    }
    if (selectedDate == null || selectedTime == null) {
      snackbarNotifier?.notify(message: 'Please select date and time'.tr());
      return false;
    }
    ControllerDebugger().dekhao("Creating Ride...");
    processStatusNotifier.setLoading();
    await serviceLocator<RideInterface>().createRide(
      CreateRideReq(
        startLocation: fromLocation!,
        endLocation: toLocation!,
        departureTime: DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        ),
        seatCount: 4,
        availableSeats: seatAvailable.value,
        pinnedNote: selectedBaggageIndex.name,
        baggageType: selectedBaggageIndex
      )
    ).then((lr) {
      handleFold(
        either: lr,
        processStatusNotifier: processStatusNotifier,
        successSnackbarNotifier: snackbarNotifier,
        errorSnackbarNotifier: snackbarNotifier
      );
    });
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    timeController.dispose();
  }
}