import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/bottomsheets/own_rider_long_press_options.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/bottomsheets/other_rider_long_press_options.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/change_baggage_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/join_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/kickout_rider_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/leave_ride_controller.dart';
import '../../../modules/profile/controller/profile_data_controller.dart';
import '../../../modules/ride&booking/model/enum/baggage_type_enum.dart';
import '../../../modules/ride&booking/ui/view/join_ride_bottomsheet.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_gap.dart';
import '../model/rider.dart';
import 'cache/smart_network_image.dart';

/// This widget is used to display a list of riders in a ride.
/// 
/// If you want to allow users to join the ride, set [allowJoin] to true and provide
/// a callback function [onJoin] to handle the join action. You should also provide a
/// [joinRideController] to manage the state of the join

class RidersListWidget extends StatefulWidget {
  final JoinRideController joinRideController;
  final LeaveRideController? leaveRideController;
  final KickoutRiderController? kickoutRiderController;
  final ChangeBaggageController? changeBaggageController;
  final bool allowJoin;
  final double avatarSize;
  final RxList<Rider> riders;
  final int seatBooked;
  final bool showLongPressOptions;
  const RidersListWidget({
    super.key,
    this.avatarSize = 55,
    required this.allowJoin,
    required this.riders,
    required this.joinRideController,
    this.changeBaggageController,
    this.leaveRideController,
    this.kickoutRiderController,
    required this.seatBooked,
    this.showLongPressOptions = true,
  });

  @override
  State<RidersListWidget> createState() => _RidersListWidgetState();
}

class _RidersListWidgetState extends State<RidersListWidget> {

  String currentUserId = "";
  final int maxUsers = 4;
  late double avatarSize;
  double containerWidth = 80;
  double spacing = 8;

  @override
  void initState() {
    super.initState();
    currentUserId = Get.find<ProfileDataController>().userProfile.value?.id ?? "";
    avatarSize = widget.avatarSize;
  }

  calculateSpace(BoxConstraints constraints) {
    containerWidth = max(0, min(containerWidth, (constraints.maxWidth - ((maxUsers - 1) * spacing)) / maxUsers));
    spacing = max(spacing, (constraints.maxWidth - ((containerWidth * (maxUsers)))) / (maxUsers - 1));
    avatarSize = min(avatarSize, containerWidth);
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        
        // return Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     spacing: spacing,
        //     children: [
        //       ...slots
        //     ],
        //   );
        return ObxValue(
          (data){
            List<Widget> slots = [];
            calculateSpace(constraints);
            for (var rider in widget.riders) {
              slots.add(
                SizedBox(
                  width: containerWidth,
                  child: _buildProfile(
                    rider,
                    rider.profileImage,
                    rider.userId == currentUserId ? "You" : rider.name,
                    rider.avgRating.toString(),
                    {rider.baggageType},
                  ),
                ),
              );
            }
      
            int totalUsers = widget.riders.length;
            int remainingSlots = maxUsers - totalUsers;
      
            if(widget.allowJoin) {
              for (int i = 0; i < remainingSlots; i++) {
                slots.add(SizedBox(width: containerWidth, child: _buildAddButton()));
              }
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: spacing,
              children: [
                ...slots
              ],
            );

          },
          widget.riders
        );
      }
    );
  }

  void _onLongPress(Rider rider) {
    if(widget.showLongPressOptions == false) return;
    debugPrint("Long press on ${rider.name}");
    if (rider.userId == currentUserId) {
      showOwnRiderLongPressOptions(
        context: context,
        rider: rider,
        leaveRideController: widget.leaveRideController,
        changeBaggageController: widget.changeBaggageController,
      );
    } else {
      if(widget.kickoutRiderController != null) {
        showOtherRiderLongPressOptions(
          context: context,
          rider: rider,
          kickoutRiderController: widget.kickoutRiderController!,
        );
      }
    }
  }

  void _showJoinBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return JoinRideBottomsheet(
          joinRideController: widget.joinRideController,
          seatBooked: widget.seatBooked,
        );
      },
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () {
        debugPrint("Join Ride tapped >> ${widget.allowJoin}");
        if (widget.allowJoin) {
          _showJoinBottomSheet();
        }
      },
      child: Column(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400, width: 2),
            ),
            child: Icon(Icons.add, color: Colors.grey.shade600, size: 20),
          ),
          Gap.h4,
          Text("Join", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProfile(
    Rider rider,
    String imagePath,
    String name,
    String rating,
    Set<BaggageType> baggageTypes,
  ) {
    return Column(
      children: [
        InkWell(
          onLongPress: () {
            _onLongPress(rider);
          },
          child: SmartNetworkImage.circle(
            imageUrl: imagePath,
            diameter: avatarSize,
            fit: BoxFit.cover,
          ),
        ),
        Gap.h4,
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 12),
            Text(rating, style: const TextStyle(fontSize: 12)),
          ],
        ),
        Gap.h4,
        //if (!baggageTypes.contains('No Baggage') && baggageTypes.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: baggageTypes.map((type) {
            String iconPath;
            iconPath = type.assetImagePath();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Image.asset(
                iconPath,
                width: 14,
                height: 14,
                color: AppColors.primaryTextblack,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
