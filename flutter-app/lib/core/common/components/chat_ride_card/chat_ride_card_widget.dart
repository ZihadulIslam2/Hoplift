
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/controller/inbox_controller.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/cache/smart_network_image.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/riders_list.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/auth_role.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/app_pigeon/app_pigeon.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/kickout_rider_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/leave_ride_controller.dart';
import '../../../../app/app_manager.dart';
import '../../widgets/car_divider_widget.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_gap.dart';

class ChatRideCardWidget extends StatefulWidget {
  final ActiveRideChatController activeRideChatController;
  
  const ChatRideCardWidget({super.key, required this.activeRideChatController});

  @override
  State<ChatRideCardWidget> createState() => _ChatRideCardWidgetState();
}

class _ChatRideCardWidgetState extends State<ChatRideCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: _LocationHeader(
              fromLocation: widget.activeRideChatController.ride.value.startLocation.address ?? "",
              toLocation: widget.activeRideChatController.ride.value.endLocation.address ?? "",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Text(
                  DateFormat.yMMMMEEEEd().format(widget.activeRideChatController.ride.value.departureTime),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryTextblack,
                  ),
                ),
                Gap.w12,
                Text(
                  DateFormat.Hm().format(widget.activeRideChatController.ride.value.departureTime),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryTextblack,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CarDivider(),
          ),
          Gap.h12,
          RidersListWidget(
            allowJoin: widget.activeRideChatController.eligibleToJoin,
            avatarSize: 50,
            riders: widget.activeRideChatController.participants,
            kickoutRiderController: widget.activeRideChatController.kickoutRiderController,
            joinRideController: widget.activeRideChatController.joinRideController,
            leaveRideController: widget.activeRideChatController.leaveRideController,
            seatBooked: 1,
          ),
          SizedBox(height: 10,),
          // _UserAvatarsRow(
          //   joinedUsers: widget.activeRide.value.participants,
          // ),
          const Divider(height: 4, color: AppColors.primarybutton),
        ],
      ),
    );
  }
}

class _LocationHeader extends StatelessWidget {
  final String fromLocation;
  final String toLocation;
  const _LocationHeader({required this.fromLocation, required this.toLocation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From'.tr(),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Flexible(
                      child: Text(
                        fromLocation,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To'.tr(),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Flexible(
                      child: Text(
                        toLocation,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _UserAvatarsRow extends StatelessWidget {
  final LeaveRideController leaveRideController;
  final KickoutRiderController kickoutRiderController;
  final List<Rider> joinedUsers;
  //final Function(String userName, Set<String> baggage) onBaggageChange;

  const _UserAvatarsRow({
    required this.joinedUsers,
    required this.leaveRideController,
    required this.kickoutRiderController,
    //required this.onBaggageChange,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
         mainAxisAlignment: MainAxisAlignment.start,
         spacing: max(0, min(16, (constraints.maxWidth - (70 * (joinedUsers.length - 1)))/(joinedUsers.length - 1))),
          children: joinedUsers
              .map(
                (user) => SizedBox(
                  width: 70,
                  child: _UserAvatar(
                    riderId: user.userId,
                    leaveRideController: leaveRideController,
                    kickoutRiderController: kickoutRiderController,
                    avatarSize: 50,
                    name: user.name,
                    rating: user.avgRating.toDouble(),
                    imageAsset: user.profileImage,
                    isCurrentUser: (Get.find<AppManager>().authStatus is! Authenticated) ? false : user.userId == (Get.find<AppManager>().authStatus as Authenticated).auth.userId,
                    baggage: {user.baggageType.toString()},
                  ),
                ),
              )
              .toList(),
        );
      }
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final double avatarSize;
  final String riderId;
  final String name;
  final double rating;
  final String imageAsset;
  final bool isCurrentUser;
  final Set<String> baggage;
  final LeaveRideController leaveRideController;
  final KickoutRiderController kickoutRiderController;

  const _UserAvatar({
    required this.riderId,
    required this.avatarSize,
    required this.name,
    required this.rating,
    required this.imageAsset,
    this.isCurrentUser = false,
    required this.baggage,
    required this.leaveRideController,
    required this.kickoutRiderController,
  });

  void _onLongPress(BuildContext context) {
    
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _onLongPress(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmartNetworkImage.circle(
            imageUrl: imageAsset,
            diameter: avatarSize,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              const SizedBox(width: 2),
              Text(
                '$rating',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          if (baggage.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: baggage.map((type) {
                final iconPath = (type == 'Large')
                    ? 'assets/images/largebaggage.png'
                    : (type == 'Small')
                    ? 'assets/images/smallbaggage.png'
                    : 'assets/images/empty.png';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Image.asset(
                    iconPath,
                    width: 16,
                    height: 16,
                    color: AppColors.primaryTextblack,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
