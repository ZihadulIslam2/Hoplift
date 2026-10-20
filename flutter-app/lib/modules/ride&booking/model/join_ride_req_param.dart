import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';

class JoinRideReqParam {
  final String rideId;
  final int seatBooked;
  BaggageType baggageType = BaggageType.small;
  JoinRideReqParam({required this.rideId, required this.seatBooked, this.baggageType = BaggageType.small});

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'seatBooked': seatBooked,
      'baggageType': baggageType.name,
    };
  }
}