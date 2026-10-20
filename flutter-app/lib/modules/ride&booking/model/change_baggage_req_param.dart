import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';

class ChangeBaggageReqParam {
  final String rideId;
  final String bookingId;
  final BaggageType baggageType;

  ChangeBaggageReqParam({required this.rideId, required this.bookingId, required this.baggageType});

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'bookingId': bookingId,
      'baggageType': baggageType.name,
    };
  }
}