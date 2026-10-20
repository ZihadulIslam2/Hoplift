import 'package:flutter/rendering.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';

class Rider {
  final BaggageType baggageType;
  final String userId;
  final num seatBooked;
  final num avgRating;
  final String name;
  final String profileImage;

  Rider({
    required this.baggageType,
    required this.userId,
    required this.seatBooked,
    required this.avgRating,
    required this.name,
    required this.profileImage,
  });



  factory Rider.fromJson(Map<String, dynamic> json) {
    try {
      return Rider(
        userId: json['_id'] ?? json['userId'],
        name: json['name'],
        seatBooked: json['seatBooked'] as num,
        profileImage: json['profileImage'] ?? "",
        avgRating: json['avgRating'] as num,
        baggageType: BaggageType.fromString(json['baggageType']),
      );
    } catch (e) {
      debugPrint("Error parsing rider: $e, json: $json");
      throw FormatException("Error parsing rider: $e");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': userId,
      'name': name,
      'seatBooked': seatBooked,
      'profileImage': profileImage,
      'avgRating': avgRating,
      'baggageType': baggageType.toString(),
    };
  }

  // copyWith
  Rider copyWith({
    BaggageType? baggageType,
    String? userId,
    num? seatBooked,
    num? avgRating,
    String? name,
    String? profileImage,
  }) {
    return Rider(
      baggageType: baggageType ?? this.baggageType,
      userId: userId ?? this.userId,
      seatBooked: seatBooked ?? this.seatBooked,
      avgRating: avgRating ?? this.avgRating,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  @override
  bool operator ==(Object other) {
    return super == other &&
        baggageType.toString() == (other as Rider).baggageType.toString();
  }

  @override
  int get hashCode => baggageType.hashCode ^ super.hashCode;

  @override
  String toString() {
    return 'Rider(baggageType: $baggageType, userId: $userId, seatBooked: $seatBooked, avgRating: $avgRating, name: $name, profileImage: $profileImage)';
  }
}