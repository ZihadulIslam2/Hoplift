import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/save_button.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/create_new_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/widget/passenger_increment_decrement_widget.dart';

import '../widget/location_input.dart';

class CreateFromSearchInputParam {
  final LocationAdress? fromLocation;
  final LocationAdress? toLocation;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int passengerCount;

  CreateFromSearchInputParam({
    this.fromLocation,
    this.toLocation,
    this.selectedDate,
    this.selectedTime,
    this.passengerCount = 1,
  });

  @override
  String toString() {
    return 'CreateRideView{inputParam: ${fromLocation.toString()}, ${toLocation.toString()}, ${selectedDate?.toIso8601String()}, ${selectedTime.toString()}:${passengerCount}}';
  }

}

class CreateRideView extends StatefulWidget {
  final CreateFromSearchInputParam? inputParam;
  const CreateRideView({super.key, this.inputParam});

  @override
  State<CreateRideView> createState() => _CreateRideViewState();
}

class _CreateRideViewState extends State<CreateRideView> {

  late final CreateNewRideController _createRideScreenController;

  @override
  void initState() {
    super.initState();
    _createRideScreenController = CreateNewRideController(widget.inputParam);
  }

  @override
  void dispose() {
    _createRideScreenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Post Ride".tr(),
          style: AppText.xlSemiBold_20_600.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () async {
              _createRideScreenController.resetForm(context);
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
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: RSaveButton(
              height: 50,
              borderRadius: BorderRadius.circular(20),
              key: UniqueKey(),
              buttonStatusNotifier:
                  _createRideScreenController.processStatusNotifier,
              saveText: 'Create'.tr(),
              loadingText: "Creating.....".tr(),
              onSaveTap: () async {
                _createRideScreenController.submitRide(
                  snackbarNotifier: SnackbarNotifier(context: context)
                );
              },
              onDone: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            LocationInputs(
              fromController: _createRideScreenController.fromController,
              toController: _createRideScreenController.toController,
              onSelectingFromLocation: (locationAddress) {
                _createRideScreenController.fromLocation = locationAddress;
              },
              onSelectingToLocation: (locationAddress) {
                _createRideScreenController.toLocation = locationAddress;
              },
            ),
            Gap.h40,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _createRideScreenController.dateController,
                    readOnly: true,
                    onTap: ()=> _createRideScreenController.selectDate(context),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: ()=> _createRideScreenController.selectDate(context),
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
                    controller: _createRideScreenController.timeController,
                    readOnly: true,
                    onTap: ()=> _createRideScreenController.selectTime(context),
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.watch_later_outlined),
                        onPressed: ()=> _createRideScreenController.selectTime(context),
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
                  "Seats Available".tr(),
                  style: AppText.lgMedium_18_500.copyWith(
                    color: AppColors.primaryTextblack,
                  ),
                ),
                const Spacer(),
                PassengerIncrementDecrementWidget(
                  count: _createRideScreenController.seatAvailable,
                  onDecrement: _createRideScreenController.decrementPassengers,
                  onIncrement: _createRideScreenController.incrementPassengers,
                ),
              ],
            ),
            
            BaggageSelector(
              initalSelectedBaggageType: BaggageType.small,
              onBaggageSelected: (p0) {
                _createRideScreenController.selectedBaggageIndex = p0;
              },
            ),
            Gap.h24,
            //buildDepartureFlexibility(),
            Gap.h40,
            //buildArrivalFlexibility(),
            Gap.h80,
            // SizedBox(
            //   width: double.infinity,
            //   height: 51,
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.primarybutton,
            //       foregroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //     child: Text(
            //       'Create'.tr(),
            //       style: AppText.lgMedium_18_500.copyWith(
            //                     color: AppColors.white,
            //                   ),
            //     ),
            //   ),
            // ),
            
          ],
        ),
      ),
    );
  }
}

class BaggageSelector extends StatefulWidget {
  final BaggageType? initalSelectedBaggageType;
  final void Function(BaggageType) onBaggageSelected;
  const BaggageSelector({super.key, required this.onBaggageSelected, this.initalSelectedBaggageType});

  @override
  // ignore: library_private_types_in_public_api
  _BaggageSelectorState createState() => _BaggageSelectorState();
}

class _BaggageSelectorState extends State<BaggageSelector> {
  int? selectedIndex;

  final List<String> baggageImages = BaggageType.values.map((type) => type.assetImagePath()).toList();

  final List<String> baggageLabels = BaggageType.values.map((type) => type.name).toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.initalSelectedBaggageType?.index;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap.h40,
        Text(
          "Please select your baggage type".tr(),
          style: AppText.xlSemiBold_20_400.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(baggageImages.length, (index) {
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  widget.onBaggageSelected(BaggageType.values[index]);
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorFiltered(
                      colorFilter: isSelected
                          ? const ColorFilter.mode(
                              AppColors.primarybutton,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.srcIn,
                            ),
                      child: Image.asset(
                        baggageImages[index],
                        width: 28,
                        height: 28,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      baggageLabels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primarybutton
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
