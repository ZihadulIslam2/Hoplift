import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/loading/ride_card_shimmer_skeleton.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/extensions/datetime_ext.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/search_and_filter_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/view/filter_rides_view.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/widget/filterchipwidget.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/components/search_ride_card/search_ride_card_widget.dart';

import '../../../../core/theme/text_style.dart';
import 'create_ride_view.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({super.key});

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {

  final SearchRideController searchRideController = Get.find<SearchRideController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Rides List'.tr(),
          style: AppText.xlSemiBold_20_600.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            tooltip: "Filter Rides",
            icon: Image.asset(
              'assets/images/filter.png',
              width: 24,
              height: 24,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterRidesView()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints2) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints2.maxWidth * 0.40,
                                  ),
                                  child: Text(
                                    searchRideController.fromLocation?.address ?? '',
                                    style: AppText.smMedium_14_600.copyWith(
                                      color: AppColors.secondaryTextblack,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: constraints2.maxWidth * 0.1,
                                  child: Text(
                                    "To",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTextblack,
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.4,
                                  ),
                                  child: Text(
                                    searchRideController.toLocation?.address ?? '',
                                    style: AppText.smMedium_14_600.copyWith(
                                      color: AppColors.secondaryTextblack,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                        SizedBox(height: 8),
                        Text(
                          searchRideController.selectedDateTime?.dmyAth24 ?? '',
                          style: AppText.smMedium_14_600.copyWith(
                            color: AppColors.secondaryTextblack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap.h12,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     // Ordenar
                //     TextButton.icon(
                //       onPressed: () {},
                //       icon: Icon(Icons.swap_vert, size: 24, color: Colors.black),
                //       label: Text('Ordenar', style: TextStyle(fontSize: 16, color: Colors.black)),
                //     ),
          
                //     // Filtrar with red dot
                //     Stack(
                //       alignment: Alignment.topRight,
                //       children: [
                //         TextButton.icon(
                //           onPressed: () {},
                //           icon: Icon(Icons.tune, size: 24, color: Colors.black),
                //           label: Text(
                //             'Filtrar',
                //             style: TextStyle(fontSize: 16,color: Colors.black),
                //           ),
                //         ),
                //       ],
                //     ),
          
                //     // Mapa
                //     TextButton.icon(
                //       onPressed: () {},
                //       icon: Icon(Icons.map_outlined, size: 24, color: Colors.black),
                //       label: Text('Mapa', style: TextStyle(fontSize: 16,color: Colors.black)),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      ()=> Row(
                        spacing: 8,
                        children: [
                          FilterChipWidget(
                            label: 'Departure Flex : ${searchRideController.filtered.value.departureFlexKm} kilometres',
                            toolTip: "Departure Flex(Km) set how much later or further from your chosen spot you’re willing to depart.".tr(),
                          ),
                          FilterChipWidget(
                            label: 'Departure Flex : ${searchRideController.filtered.value.departureFlexMinutes} min',
                            toolTip: "Departure Flex(Minutes) set how much later or further from your chosen time you’re willing to depart.".tr(),
                          ),
                          FilterChipWidget(
                            label: 'Arrival Flex : ${searchRideController.filtered.value.arrivalFlexKm} kilometres',
                            toolTip: "Arrival Flex set how much further from your chosen spot you’re willing to arrive.".tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          
                Expanded(
                  child: Obx(
                    ()=> 
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: searchRideController.searchResults.length + 1,
                      itemBuilder: (context, index) {
                        if(index == searchRideController.searchResults.length) {
                          if(searchRideController.isSearching.value) {
                            return Column(
                              children: [
                                ...List.generate(10, (_)=>
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: BookedRideCardSkeleton()
                                  )
                                )
                              ],
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: searchRideController.isSearching.value ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primarybutton),
                              ) : Text(
                                searchRideController.searchResults.isEmpty ? "No rides found!".tr() : 'No more rides.'.tr(),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }
                        final ride = searchRideController.searchResults[index];
                        return SearchRideCardWidget.fromRide(
                          ride,
                          allowJoin: true,
                          seatBooked: searchRideController.passengers.value,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 185,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateRideView(
                            inputParam: CreateFromSearchInputParam(
                              fromLocation: searchRideController.fromLocation,
                              toLocation: searchRideController.toLocation,
                              selectedDate: searchRideController.selectedDateTime,
                              selectedTime: searchRideController.selectedTime,
                              passengerCount: searchRideController.passengers.value
                            ),
                          )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primarybutton,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Create Ride',
                        style: AppText.lgMedium_18_500.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
