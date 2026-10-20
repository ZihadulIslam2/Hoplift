import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/save_button.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/widget/notification_bell_widget.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/profile_data_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/widget/greeting_user_widget.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/search_and_filter_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/view/create_ride_view.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/view/search_result_view.dart';
import '../../../../core/notifiers/button_status_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gap.dart';
import '../../../../core/theme/text_style.dart';
import '../widget/location_input.dart';
import '../widget/passenger_increment_decrement_widget.dart';

class SearchScreenView extends StatefulWidget {
  const SearchScreenView({super.key});

  @override
  State<SearchScreenView> createState() => _SearchScreenViewState();
}

class _SearchScreenViewState extends State<SearchScreenView> with AutomaticKeepAliveClientMixin{
  late final SearchRideController searchRideController;
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier(initialStatus: EnabledStatus());
  
  int passengers = 1;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('SearchScreenView initState');
    searchRideController = Get.find<SearchRideController>();   
    searchRideController.initializeDefaultValues(); 
    Get.find<ProfileDataController>().getCurrentUserProfile();
  }

  @override
  void dispose() {
    //searchRideController.dispose();
    // _dateController.dispose();
    // _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/1111111.png',
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
          // Greeting section
          Positioned(
            top: 50,
            left: 24,
            right: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white30,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GreetingUserWidget(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome back to'.tr(),
                              style: TextStyle(color: AppColors.primaryTextblack),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(color: AppColors.primaryTextblack),
                            ),
                            TextSpan(
                              text: 'Hoplift'.tr(),
                              style: TextStyle(color: AppColors.primaryTextblack),
                            ),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                ),

                NotificationBellWidget(),
                
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.62,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 0,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap.h32,
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
                      Gap.h24,
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchRideController.dateController,
                              readOnly: true,
                              onTap:() => searchRideController.selectDate(context),
                              decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today_outlined,
                                  ),
                                  onPressed:() => searchRideController.selectDate(context),
                                ),
                                hintText: 'Date'.tr(),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
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
                          Gap.w8,
                          Expanded(
                            child: TextField(
                              controller: searchRideController.timeController,
                              readOnly: true,
                              onTap:()async => searchRideController.selectTime(context),
                              decoration: InputDecoration(
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.watch_later_outlined,
                                  ),
                                  onPressed:()async => searchRideController.selectTime(context),
                                ),
                                hintText: 'Time'.tr(),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
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
                      Gap.h16,
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 28),
                          Gap.w12,
                          Text(
                            "Passengers".tr(),
                            style: AppText.mdRegular_16_400.copyWith(
                              color: AppColors.primaryTextblack,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              PassengerIncrementDecrementWidget(
                                count: searchRideController.passengers,
                                onDecrement: searchRideController.decrementPassengers,
                                onIncrement: searchRideController.incrementPassengers,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap.h24,
                      ///////////
                      RSaveButton(
                        key: UniqueKey(),
                        saveText: 'Search'.tr(),
                        loadingText: "Search".tr(),
                        buttonStatusNotifier: processStatusNotifier,
                        onSaveTap: () => searchRideController.searchRide(
                          snackbarNotifier: SnackbarNotifier(context: context),
                          processStatusNotifier: processStatusNotifier,
                        ),
                        onDone: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsView(),
                            ),
                          );
                        },
                      ),
                      
                      Gap.h16,
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateRideView(
                                inputParam: CreateFromSearchInputParam(
                                  fromLocation: searchRideController.fromLocation,
                                  toLocation: searchRideController.toLocation,
                                  selectedDate: searchRideController.selectedDate,
                                  selectedTime: searchRideController.selectedTime,
                                  passengerCount: searchRideController.passengers.value,
                                ),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(color: AppColors.primarybutton),
                        ),
                        child: Text(
                          'Create Ride'.tr(),
                          style: AppText.lgMedium_18_500.copyWith(
                            color: AppColors.primarybutton,
                          ),
                        ),
                      ),
                      Gap.h24,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
