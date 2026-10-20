import 'package:ttrueno_fo827e642a0c4/core/common/model/rider.dart';

class RiderJoinedState {
  final String rideId;
  final String chatId;
  final Rider rider;
  RiderJoinedState({required this.rideId, required this.chatId, required this.rider});

  factory RiderJoinedState.fromJson(Map<String, dynamic> json) =>
      RiderJoinedState(
        rideId: json['rideId'],
        chatId: json['chatId'],
        rider: Rider.fromJson(json['rider']),
      );
}
