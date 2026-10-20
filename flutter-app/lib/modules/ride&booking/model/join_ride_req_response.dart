
import 'dart:math';

import '../../../core/common/model/rider.dart';

class JoinRideReqResponse {
  final List<Rider> joinedRiders;
  JoinRideReqResponse({
    required this.joinedRiders,
  });

  factory JoinRideReqResponse.fromJson(Map<String, dynamic> json) {
    return JoinRideReqResponse(
      joinedRiders: (json["ride"]['participants'] as List<dynamic>).map((e)=> Rider.fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    return 'JoinRideReqResponse(joinedRideResponse: ${joinedRiders.map((e) => e.toString()).join("\n ")})';
  }

}