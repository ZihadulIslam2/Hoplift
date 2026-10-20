import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/debug/debug_service.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/ride_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/filter_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../main.dart';
import '../model/filter_ride_req_param.dart';

class SearchRideController extends GetxController {
  SearchRideController();
  
  RxBool isSearching = RxBool(false);
  final RxList<RideModel> searchResults = RxList<RideModel>();
  Rx<FilterModel> filtered = Rx(FilterModel(
    arrivalFlexKm: .2,
    departureFlexKm: .2,
    departureFlexMinutes: 15,
  ));
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );
  LocationAdress? fromLocation;
  LocationAdress? toLocation;
  DateTime? _selectedDateTime;
  DateTime? get selectedDateTime => _selectedDateTime;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  RxInt passengers = RxInt(1);
  RxDouble departureFlexKm = RxDouble(.2);
  RxDouble arrivalFlexKm = RxDouble(.2);
  /// In minutes
  RxInt departureFlexMinutes = RxInt(15);

  Future<void> initializeDefaultValues() async {
    final now = DateTime.now();
    selectedDate = now;
    selectedTime = TimeOfDay.fromDateTime(now);
    dateController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    timeController.text = selectedTime!.format(navigatorKey.currentContext!);
    passengers.value = 1;
  }


  Future<void> selectDate(BuildContext context) async {
    debugPrint("Selecting date");
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      selectedDate = picked;
      _selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedTime?.hour ?? 0,
        selectedTime?.minute ?? 0,
      );
      dateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    } else {
      debugPrint("Date not selected");
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
      _selectedDateTime = DateTime(
        selectedDate?.year ?? 0,
        selectedDate?.month ?? 0,
        selectedDate?.day ?? 0,
        picked.hour,
        picked.minute,
      );
      if (context.mounted) timeController.text = picked.format(context);
    }
  }

  void incrementPassengers() {
    if (passengers < 4) passengers++;
  }

  void decrementPassengers() {
    if (passengers > 1) passengers--;
  }

  void resetForm(BuildContext context) async {
    final now = DateTime.now();
    selectedDate = now;
    dateController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    selectedTime = TimeOfDay.fromDateTime(now);
    timeController.text = selectedTime!.format(context);
    passengers.value = 1;
    fromController.clear();
    toController.clear();
    arrivalFlexKm.value = .2;
    departureFlexKm.value = .2;
    departureFlexMinutes.value = 15;
    isSearching.value = false;
  }

  int _page = 1;
  final int _limit = 20;
  bool _allLoaded = false;

  Future<void> searchRide({
    SnackbarNotifier? snackbarNotifier,
    ProcessStatusNotifier? processStatusNotifier,
    bool forceRefresh = false,
  }) async {
    // Validate inputs
    if (fromLocation == null || toLocation == null) {
      snackbarNotifier?.notify(message: 'Please fill in both locations'.tr());
      return;
    }
    if (selectedDate == null || selectedTime == null) {
      snackbarNotifier?.notify(message: 'Please select date and time'.tr());
      return;
    }
    ControllerDebugger().dekhao("Searching Ride...");
    // if(forceRefresh) {
    //   _page = 1;
    //   _allLoaded = false;
    //   searchResults.clear();
    // }
    searchResults.clear();
    processStatusNotifier?.setLoading();
    isSearching.value = true;
    await serviceLocator<RideInterface>().filterRide(
      params: FilterRideReqParam(
        arrivalFlexKm: arrivalFlexKm.value,
        departureFlexKm: departureFlexKm.value,
        departureFlexMinutes: departureFlexMinutes.value,
        fromLat: fromLocation!.lat ?? 0.0,
        fromLng: fromLocation!.lng ?? 0.0,
        toLat: toLocation!.lat ?? 0.0,
        toLng: toLocation!.lng ?? 0.0,
        departureTime: DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        ),
        passengers: passengers.value
      )
    ).then((lr) {
      handleFold(
        either: lr,
        processStatusNotifier: processStatusNotifier,
        //successSnackbarNotifier: snackbarNotifier,
        errorSnackbarNotifier: snackbarNotifier,
        onSuccess: (data) {
          
          if (data.isEmpty) {
            snackbarNotifier?.notify(message: 'No rides found'.tr());
          }
          searchResults.value = data;
          filtered.value = FilterModel(
            arrivalFlexKm: arrivalFlexKm.value,
            departureFlexKm: departureFlexKm.value,
            departureFlexMinutes: departureFlexMinutes.value,
          );
          
        },
      );
    });
    isSearching.value = false;
    Future.delayed(Duration(seconds: 1)).then((_){processStatusNotifier?.setEnabled();});
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
