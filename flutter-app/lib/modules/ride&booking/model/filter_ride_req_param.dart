
class FilterRideReqParam {
  final double arrivalFlexKm;
  final double departureFlexKm;
  final num departureFlexMinutes;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final DateTime departureTime;
  final int passengers;

  FilterRideReqParam({
    required this.arrivalFlexKm,
    required this.departureFlexKm,
    required this.departureFlexMinutes,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.departureTime,
    required this.passengers,
  });


  Map<String, dynamic> toJson() {
    return {
      'arrivalFlexKm': arrivalFlexKm,
      'departureFlexKm': departureFlexKm,
      'departureFlexMinutes': departureFlexMinutes,
      'fromLat': fromLat,
      'fromLng': fromLng,
      'toLat': toLat,
      'toLng': toLng,
      'departureTime': departureTime.toUtc().toIso8601String(),
      "passengers": passengers
    };
  }

}
