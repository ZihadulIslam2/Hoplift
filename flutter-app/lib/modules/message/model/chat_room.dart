import 'package:flutter/foundation.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

class ChatRoom {
  final String id;
  final RideModel ride;
  final String name;
  final bool isGroup;
  final List<Rider> participants;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatRoom({
    required this.id,
    required this.ride,
    required this.name,
    required this.isGroup,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    try {
      return ChatRoom(
        id: json['_id'] as String,
        ride: RideModel.rideAndParticipants(json['ride'], (json['participants'] as List<dynamic>?) ?? []),
        name: json['name'] as String,
        isGroup: false,//json['isGroup'] as bool,
        participants: json['participants'] == null
            ? []
            : List<Rider>.from(
                json['participants']?.map((x) => Rider.fromJson(x)) ?? [],
              ),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      );
    } catch (e) {
      debugPrint("Error in ChatRoom.fromJson: $e, json: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'rideId': ride,
    'name': name,
    'isGroup': isGroup,
    'participants': participants.map((x) => x.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
