import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/debug/debug_service.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/search_and_filter_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/widget/location_input.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/widget/slider_widget.dart';

import '../../../../core/common/widgets/reactive_buttons/save_button.dart';
import '../../../../core/notifiers/snackbar_notifier.dart';
import '../widget/passenger_increment_decrement_widget.dart';

class FilterRidesView extends StatefulWidget {
  const FilterRidesView({super.key});

  @override
  State<FilterRidesView> createState() => _FilterRidesViewState();
}

class _FilterRidesViewState extends State<FilterRidesView> {
  final SearchRideController searchRideController = Get.find<SearchRideController>();
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: EnabledStatus());
  @override
  void initState() {
    super.initState();
  }

  
  double calculateSliderValueFromDistance(double distanceKM,) {
    final distancemeter = distanceKM * 1000;
    if (distancemeter < 2000) {
      final slidervalue = ((distancemeter / 100).floor()) * 0.25;
      return slidervalue.toDouble();
    } else {
      double slidervalue = 5;
      slidervalue += (distancemeter / 8000).floor() * 5;
      return slidervalue.toDouble();
    }
  }

  double calculateSliderValueFromMinutes(double minutes) {
    if (minutes < 60) {
      final slidervalue = ((minutes / 15).floor()) * 1.25;
      return slidervalue.toDouble();
    } else {
      double slidervalue = 5;
      minutes -= 60;
      slidervalue += (minutes / 60).floor() * 1.25;
      return slidervalue.toDouble();
    }
  }

  double calculateSliderDistance(double value) {
    if (value < 5) {
      // 5/20 = 0.25                
      final metre = ((value / .25).floor()) * 100;
      final km = metre / 1000;
      return km.toDouble();
    } else {
      // 5/8 = 0.625
      double km = 2;
      value -= 5;
      km += (value / .625).floor();
      return km.toDouble();
    }
  }

  int calulateMinuteSlider(double value) {
    if (value < 5) {
      // 5/4 = 1.25
      final minutes = (value / 1.25).floor() * 15;
      return minutes;
    } else {
      // 5/4 = 1.25
      int minutes = 60;
      value -= 5;
      minutes += (value / 1.25).floor() * 60;
      ControllerDebugger().dekhao("Minutes: $minutes");
      return minutes;
    }
  }

  String _formatDistanceText(double km) {
    return "${km.toStringAsFixed(1)} km";
  }

  String _formatAllowedTimeText(int minutes) {
    if (minutes < 60) return "$minutes min";
    int h = minutes ~/ 60;
    int m = minutes % 60;
    return m > 0 ? "${h}h ${m}m" : "${h}h";
  }

  Widget buildDepartureFlexibility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: "Departure Flex set how much later or further from your chosen spot you’re willing to depart.",
          margin: EdgeInsets.all(8),
          child: Row(
            spacing: 6,
            children: [
              Text(
                "Departure Flexibility".tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.info_outline,
                color: AppColors.primaryTextblack,
              )
            ],
          ),
        ),
        Gap.h16,
        _distanceSlider(searchRideController.departureFlexKm),
        Gap.h24,
        // Time flexibility
        Row(
          children: [
            Expanded(
              child: SliderWidget(
                key: UniqueKey(),
                // initialValue: 1.25,
                initialValue: calculateSliderValueFromMinutes(
                  searchRideController.departureFlexMinutes.value.toDouble(),
                ),
                onValueChange: (p0) {
                  debugPrint(p0.toString());
                  searchRideController.departureFlexMinutes.value =
                      calulateMinuteSlider(p0);
                },
              ),
            ),
            Gap.w16,
            Obx(
              () => Text(
                _formatAllowedTimeText(
                  searchRideController.departureFlexMinutes.value,
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _distanceSlider(RxDouble rxDistance) {
    return Row(
      children: [
        Expanded(
          child: SliderWidget(
            key: UniqueKey(),
            initialValue: calculateSliderValueFromDistance(rxDistance.value),
            onValueChange: (p0) {
              rxDistance.value = calculateSliderDistance(p0);
            },
          ),
        ),
        Gap.w16,
        Obx(
          () => Text(
            _formatDistanceText(rxDistance.value),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget buildArrivalFlexibility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(
          message: "Arrival Flex set how much farther from your chosen spot you’re willing to arrive.",
          margin: EdgeInsets.all(8),
          child: Row(
            spacing: 6,
            children: [
              Text(
                "Arrival Flexibility".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(
                Icons.info_outline,
                color: AppColors.primaryTextblack,
              )
            ],
          ),
        ),
        
        Gap.h16,
        _distanceSlider(searchRideController.arrivalFlexKm),
        Gap.h24,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filters".tr(),
          style: AppText.xlSemiBold_20_600.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              searchRideController.resetForm(context);
              setState(() {});
            },
            child: Text(
              "Reset".tr(),
              style: AppText.lgMedium_18_400.copyWith(
                color: AppColors.primarybutton,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            LocationInputs(
              fromController: searchRideController.fromController,
              toController: searchRideController.toController,
              onSelectingFromLocation: (locationAddress) {
                searchRideController.fromLocation = locationAddress;
              },
              onSelectingToLocation: (locationAddress) {
                searchRideController.toLocation = locationAddress;
              },
            ),
            Gap.h40,
            // ... rest of your UI unchanged
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchRideController.dateController,
                    readOnly: true,
                    onTap: () async => searchRideController.selectDate(context),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: () async =>
                            searchRideController.selectDate(context),
                      ),
                      hintText: 'Date'.tr(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppColors.primarybutton,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap.w12,
                Expanded(
                  child: TextField(
                    controller: searchRideController.timeController,
                    readOnly: true,
                    onTap: () async => searchRideController.selectTime(context),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.watch_later_outlined),
                        onPressed: () async =>
                            searchRideController.selectTime(context),
                      ),
                      hintText: 'Time'.tr(),
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppColors.primarybutton,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap.h40,
            Row(
              children: [
                const Icon(Icons.person_outline, size: 28),
                Gap.w12,
                Text(
                  "Passengers".tr(),
                  style: AppText.lgMedium_18_500.copyWith(
                    color: AppColors.primaryTextblack,
                  ),
                ),
                const Spacer(),
                PassengerIncrementDecrementWidget(
                  count: searchRideController.passengers,
                  onDecrement: searchRideController.decrementPassengers,
                  onIncrement: searchRideController.incrementPassengers,
                ),
              ],
            ),
            Gap.h24,
            buildDepartureFlexibility(),
            Gap.h40,
            buildArrivalFlexibility(),
            Gap.h80,
            ///////////
            RSaveButton(
              key: UniqueKey(),
              saveText: 'Apply'.tr(),
              loadingText: "Apply".tr(),
              buttonStatusNotifier: processStatusNotifier,
              onSaveTap: () => searchRideController.searchRide(
                snackbarNotifier: SnackbarNotifier(context: context),
                processStatusNotifier: processStatusNotifier,
              ),
              onDone: () {
                debugPrint("filter done");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomThumbShape extends RoundSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(16, 16);
}
