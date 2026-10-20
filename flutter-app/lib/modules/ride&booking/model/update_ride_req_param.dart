import '../../location/model/location_address.dart';

class UpdateRideReqParam {
  final String rideId;
  LocationAdress? endLocation;
  int? availableSeatCount;
  String? pinnedNote;

  UpdateRideReqParam({
    required this.rideId,
    this.endLocation,
    this.availableSeatCount,
    this.pinnedNote,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rideId'] = rideId;
    if (endLocation != null) {
      data['endLocation'] = endLocation!.toJson();
    }
    if (availableSeatCount != null) {
      data['availableSeatCount'] = availableSeatCount;
    }
    if (pinnedNote != null) {
      data['pinnedNote'] = pinnedNote;
    }
    return data;
  }
}