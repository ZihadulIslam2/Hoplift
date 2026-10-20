
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/pagination.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/chat_room.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/finish_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/join_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/kickout_rider_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/leave_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';
import '../interface/message_interface.dart';
import '../model/get_chats_req_param.dart';
import '../model/get_messages_param.dart';
import '../model/message.dart';
import '../model/send_message_req_param.dart';
import '../../profile/controller/profile_data_controller.dart';
import '../../ride&booking/interface/ride_interface.dart';
import '../../ride&booking/model/enum/baggage_type_enum.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/common/model/rider.dart';
import '../../../core/common/model/rider_joined_state.dart';
import '../../../core/common/model/rider_left_state.dart';
part '../../../core/common/components/chat_ride_card/active_ride_chat_controller.dart';


class InboxController extends GetxController{

  InboxController();
  final int _limit = 10;
  Rx<Pagination<ActiveRideChatController>> rideChatPages =
      Rx<Pagination<ActiveRideChatController>>(
        NotInitialized<ActiveRideChatController>([]),
      );
  bool _isLastPage = false;

  Future<void> init() async{
    await getAllChat(forceRefresh: true);
    _lisenToStreams();
  }

  StreamSubscription<RiderJoinedState>? _riderJoinedStreamSubscription;
  StreamSubscription<RiderLeftState>? _riderLeftStreamSubscription;
  StreamSubscription<Message?>? _messageStreamSubscription;
  StreamSubscription<ChatRoom?>? _chatRoomStreamSubscription;

  Future<ActiveRideChatController?> getChatById(String chatId) async{
    for(int i = 0; i < rideChatPages.value.data.length; i++) {
      if(rideChatPages.value.data[i].chat.id == chatId) {
        return rideChatPages.value.data[i];
      }
    }
    return null;
  }

  Future<ActiveRideChatController?> getChatByRideId(String rideId) async{
    for(int i = 0; i < rideChatPages.value.data.length; i++) {
      if(rideChatPages.value.data[i].ride.value.id == rideId) {
        return rideChatPages.value.data[i];
      }
    }
    return null;
  }
  
  Future<void> getAllChat({bool? forceRefresh}) async{
    if(forceRefresh == true) {
      _isLastPage = false;
      rideChatPages.value = RefreshingPage([]);
    } else {
      if(_isLastPage) {
        return;
      }
      if(rideChatPages.value is LoadingMorePage || rideChatPages.value is RefreshingPage) {
        return;
      }
      rideChatPages.value = LoadingMorePage(rideChatPages.value.data);
    }

    await serviceLocator<MessageInterface>().getAllChat(
      GetChatsParam(page: rideChatPages.value.page, limit: _limit)
    ).then((lr) {
      handleFold(
        either: lr,
        processStatusNotifier: null,
        onSuccess: (data) {
          List<ActiveRideChatController> page = [];
          for(final chat in data) {
            final activeRideChat = ActiveRideChatController(_refresh, _refresh, _refresh, chat: chat);
            page.add(activeRideChat);
            activeRideChat.init();
          }
          rideChatPages.refresh();
          if(data.length < _limit) {
            _isLastPage = true;
          }
          rideChatPages.value = Loaded(rideChatPages.value is RefreshingPage ? page : [...rideChatPages.value.data, ...page]); 
          rideChatPages.refresh(); 
        },
      );
    });
  }

  void _refresh() async{
    await getAllChat(forceRefresh: true);
  }

  _lisenToStreams() {
    // When chat room is created/updated   ----- excluding the delete functionality
    _chatRoomStreamSubscription = serviceLocator<MessageInterface>().chatStream().listen((chatRoom) {
      if(chatRoom == null) return;
      // find the existing chat
      final index = rideChatPages.value.data.indexWhere((e) => e.chat.id == chatRoom.id);
      if(index != -1) {
        // Yet not exists? 
        //Add new [ActiveRideChatController] to the list
        rideChatPages.value.data.add(ActiveRideChatController(_refresh, _refresh, _refresh, chat: chatRoom));
      } else {
        // Update the existing
        rideChatPages.value.data[index] = ActiveRideChatController(_refresh, _refresh, _refresh, chat: chatRoom);
        rideChatPages.refresh();
      }
    });

    // When message is created/updated   ----- excluding the delete functionality
    _messageStreamSubscription = serviceLocator<MessageInterface>().messageStream().listen((message) async{
      if(message == null) return;
      // find the existing chat
      final int index = rideChatPages.value.data.indexWhere((e) => e.chat.id == message.chatId);
      if(index != -1) {
        rideChatPages.value.data[index]._addMessage(message);
        // logic to update participants [if its a system message like ride joined/ride left]
        if(message.type == MessageType.system) {
          debugPrint("New system message: ${message.message}");
          await serviceLocator<RideInterface>().getRideById(rideId: rideChatPages.value.data[index].rideId).then((lr) {
            handleFold(
              either: lr,
              processStatusNotifier: null,
              onSuccess: (data) {
                rideChatPages.value.data[index].participants.value = data.participants;
                rideChatPages.value.data[index].participants.refresh();
                debugPrint("Ride chat updated");
              },
            );
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _riderJoinedStreamSubscription?.cancel();
    _riderLeftStreamSubscription?.cancel();
    _chatRoomStreamSubscription?.cancel();
    _messageStreamSubscription?.cancel();
    rideChatPages.value.data.clear();
    rideChatPages.close();
  }
}

// extension ToRider on RiderStreamState{
//   bool get isJoined => riderState == RiderState.joined;

//   Rider get rider => Rider(id: id, name: name, email: email, number: number, imageUrl: imageUrl, rating: rating, baggageType: baggageType);
// }
