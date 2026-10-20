import 'package:flutter/widgets.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/status.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

class Booking {
  final String id;
  final RideModel ride;
  final Status status;
  final bool kicked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.ride,
    required this.status,
    required this.kicked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    debugPrint("ride: ${RideModel.fromJson(json['ride'])}");
    try {
        return Booking(
        id: json['_id'] as String,
        ride: RideModel.fromJson(json['ride']),
        status: Status.fromString(json['status']),
        kicked: json['kicked'] as bool,
        createdAt: DateTime.parse(json['createdAt']).toLocal(),
        updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      );
    } catch (e) {
      debugPrint("Booking.fromJson error: $e, json: $json");
      rethrow;
    }
  }
}
