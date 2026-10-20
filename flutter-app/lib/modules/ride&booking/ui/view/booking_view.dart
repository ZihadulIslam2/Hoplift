import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/my_booking_controller.dart';
import '../../../../core/common/components/booked_ride_card/booked_ride_card.dart';
import '../../../../core/common/widgets/list/paginated_list.dart';
import '../../../../core/common/widgets/loading/ride_card_shimmer_skeleton.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  final MyBookingControllers bookingControllers = Get.find<MyBookingControllers>();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    bookingControllers.active.getBookings(snackbarNotifier: SnackbarNotifier(context: context));
    bookingControllers.completed.getBookings(snackbarNotifier: SnackbarNotifier(context: context));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Booking'.tr(),
          style: AppText.xl2Medium_22_500.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primarybutton,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primarybutton,
          tabs: [
            Tab(text: 'Active'.tr()),
            Tab(text: 'Completed'.tr()),
            //Tab(text: 'Cancelled'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PaginatedListWidget(
            emptyMessage: "No bookings, right now!, Try refreshing!".tr(),
            pagination: bookingControllers.active.paginatedbookedRideControllers,
            skeleton: BookedRideCardSkeleton(),
            skeletonCount: 4,
            onRefresh:()=> bookingControllers.active.getBookings(forceRefresh: true),
            builder: (index, data) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BookedRideCard.fromRide(
                    data.booking.ride,
                    data,
                    allowJoin: true,
                    elevation: 2,
                  ),
                );
            },
          ),
          PaginatedListWidget(
            emptyMessage: "No bookings found!".tr(),
            pagination: bookingControllers.completed.paginatedbookedRideControllers,
            skeleton: BookedRideCardSkeleton(),
            skeletonCount: 4,
            onRefresh:()=> bookingControllers.completed.getBookings(forceRefresh: true),
            builder: (index, data) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BookedRideCard.fromRide(
                    data.booking.ride,
                    data,
                    allowJoin: false,
                    elevation: 2,
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

