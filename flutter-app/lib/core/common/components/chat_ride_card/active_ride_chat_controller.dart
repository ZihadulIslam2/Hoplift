
part of '../../../../modules/message/controller/inbox_controller.dart';


class ActiveRideChatController extends GetxController{
  
  ActiveRideChatController(this.onLeaveSuccess, this.onFinishRideSuccess, this.onKickSuccess, {required this.chat}){
    ride = Rx<RideModel>(chat.ride);
    participants.addAll(chat.participants);
    
    kickoutRiderController = KickoutRiderController(rideId: chat.ride.id, onKickSuccess: onKickSuccess);
    leaveRideController = LeaveRideController(ride: chat.ride, onLeaveSuccess: onLeaveSuccess);
    joinRideController = JoinRideController(ride: chat.ride, onJoinSuccess: (riders) {
      onJoinSuccess(riders);
    });
    finishRideController = FinishRideController(ride: chat.ride, onFinishRideSuccess: onFinishRideSuccess);
  }

  final ChatRoom chat;
  final VoidCallback onLeaveSuccess;
  final VoidCallback onFinishRideSuccess;
  final VoidCallback onKickSuccess;

  late Rx<RideModel> ride;
  String get rideId => chat.ride.id;
  bool eligibleToJoin = false;
  bool eligibleToLeave = false;
  bool eligibleForChat = false;
  RxList<Rider> participants = RxList<Rider>([]);
  RxList<Message> messages = RxList<Message>([]);
  RxString notification = RxString("");
  int _page = 1;
  int _limit = 20;
  bool _allLoaded = false;
  late final JoinRideController joinRideController;
  late final LeaveRideController leaveRideController;
  late final KickoutRiderController kickoutRiderController;
  late final FinishRideController finishRideController;

  ProcessStatusNotifier get leaveRideStn => leaveRideController.stn;
  ProcessStatusNotifier get joinRideStn => joinRideController.stn;

  init() {
    getMessages();
    serviceLocator<MessageInterface>().joinRoom(chat.id);
  }

  bool get canFinishNow {
    return ride.value.departureTime.add(Duration(hours: 2)).isBefore(DateTime.now());
  }

  void onJoinSuccess(List<Rider> newRiders) {
    participants.addAll(newRiders);
  }

  leaveRide({SnackbarNotifier? snackbarNotifier}) async{
    await leaveRideController.leaveRide(snackbarNotifier: snackbarNotifier);
  }
  
  _addMessage(Message message) {
    messages.add(message);
    messages.refresh();
  }

  /// This will be used for updating the message in the list... maybe later
  _updateMessage(Message message) {
    final index = messages.indexWhere((e) => e.id == message.id);
    messages[index] = message;
    messages.refresh();
  }

  addNewRider(Rider rider) {
    if(participants.length >= 4) return;
    participants.add(rider);
    participants.refresh();
  }

  removeRider(String userId) {
    final int index = participants.lastIndexWhere((e) => e.userId == userId);
    participants.removeAt(index);
    participants.refresh();
  }

  getMessages({bool refresh = false}) async{
    if(messages.isNotEmpty) {
      return;
    }
    if(_allLoaded && refresh == false) {
      return;
    }
    if(refresh) {
      _page = 1;
    }
    await serviceLocator<MessageInterface>().getMessages(GetMessagesParam(chatId: chat.id, page: _page, limit: _limit)).then((lr) {
      handleFold(
        either: lr,
        processStatusNotifier: null,
        onSuccess: (data) {
          for(var message in data) {
            _addMessage(message);
          }
          _page++;
          if(data.length < _limit) {
            _allLoaded = true;
          }
          debugPrint("Fetched Messages: ${messages.length}");
          messages.refresh();
        },
      );
    });
  }

  Future<bool> sendMessage(SendMessageReqParam param) async{
    bool state = false;
    await serviceLocator<MessageInterface>().sendMessage(param).then((lr) {
      handleFold(
        either: lr,
        processStatusNotifier: null,
        onSuccess: (data) {
          state = true;
        },
      );
    });
    return state;
  }

  void onBaggageChangeSuccess(BaggageType baggageType) {
    for(int i = 0; i < participants.length; i++) {
      if(participants[i].userId == Get.find<ProfileDataController>().userProfile.value?.id) {
        participants[i] = participants[i].copyWith(baggageType: baggageType);
      }
    }
    participants.refresh();
  }
}
