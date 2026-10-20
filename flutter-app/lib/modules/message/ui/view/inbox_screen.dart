import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/cache/smart_network_image.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/list/paginated_list.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/loading/inbox_chat_skeleton.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/extensions.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/ui/view/messaging_screen.dart';

import '../../controller/inbox_controller.dart';
import '../../../../core/common/model/rider.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with AutomaticKeepAliveClientMixin{
  
  late final InboxController chatListController;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatListController = Get.find<InboxController>();
    chatListController.init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Inbox'.tr(),
          style: AppText.xl2Medium_22_500.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PaginatedListWidget(
          emptyMessage: "No chats, right now!, Try refreshing!".tr(),
          pagination: chatListController.rideChatPages,
          onRefresh: () => chatListController.getAllChat(forceRefresh: true), 
          skeleton: InboxChatSkeleton(), skeletonCount: 4, 
          builder: (index, rideChat) {
            return _ChatBriefWidget(
              rideChat: rideChat,
              participants: rideChat.chat.participants,
            );
          }
        ),
      )
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class _ChatBriefWidget extends StatelessWidget {
  const _ChatBriefWidget({
    super.key,
    required this.rideChat,
    required this.participants,
  });

  final ActiveRideChatController rideChat;
  final List<Rider> participants;
  
  
  double chatHeadWidthOffsetFromLeft({required double containerWidth, required double chatHeadDiameter, required int index, required int totalItems}) {
    final minOverLayOffset = 24;
    final togetherHeadsWidth = (chatHeadDiameter * totalItems) - (minOverLayOffset * (totalItems - 1));
    final minusVal = togetherHeadsWidth - containerWidth;
    final finalOverlayOffset = minOverLayOffset + ((minusVal <= 0) ? 0 : (minusVal / max(1, (totalItems - 1))));
    final double emptySpace = containerWidth - ((totalItems * chatHeadDiameter) - ((totalItems - 1) * finalOverlayOffset));
    final double leftOffset = emptySpace + ((index * chatHeadDiameter) - (max(0, (index)) * finalOverlayOffset));
    return leftOffset;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MessagingScreen(
            activeRideChatController: rideChat,
          )),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text Section
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.6,
                          child: Row(
                            spacing: 6,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(child: Text(rideChat.ride.value.startLocation.address ?? "..", maxLines: 2, style: TextStyle(fontSize: 18, color: AppColors.primaryTextblack),)),
                              Text("To ".tr(), style: TextStyle(fontSize: 18, color: AppColors.primaryTextblack,),),
                              Flexible(child: Text(rideChat.ride.value.endLocation.address ?? "..", maxLines: 2, style: TextStyle(fontSize: 18, color: AppColors.primaryTextblack),)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.4,
                          height: 50,
                          child: Stack(
                            children: List.generate(participants.length, (i) {
                              return Positioned(
                                  left: chatHeadWidthOffsetFromLeft(
                                    containerWidth: constraints.maxWidth * 0.4,
                                    chatHeadDiameter: 48,
                                    index: i,
                                    totalItems: participants.length,
                                  ),
                                child: SmartNetworkImage.circle(
                                  diameter: 48,
                                  imageUrl: participants[i].profileImage,
                                )
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Text(
                            DateFormat.MMMEd().format(rideChat.ride.value.departureTime), style: TextStyle(fontSize: 16, color: AppColors.primaryTextblack),
                          ),
                          Gap.w12,
                          Text(
                            DateFormat.Hm().format(rideChat.ride.value.departureTime),style: TextStyle(fontSize: 16, color: AppColors.primaryTextblack),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(
                      width: constraints.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.done_all,
                                //   size: 16,
                                //   color: Colors.deepPurple,
                                // ),
                                // SizedBox(width: 4),
                                Flexible(
                                  child: Obx(
                                    ()=> Text(
                                      (rideChat.messages.isNotEmpty) ? rideChat.messages.last.message : "...",
                                      maxLines: 2,
                                      style: AppText.lgMedium_18_400.copyWith(
                                        color: AppColors.secondaryTextblack,
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                          Flexible(
                            child: Obx(
                              ()=> Text(
                                rideChat.messages.isNotEmpty
                                    ? rideChat.messages.first.updatedAt
                                          .toChatTimeString()
                                    : '..:.. am/pm',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  
  }
}
