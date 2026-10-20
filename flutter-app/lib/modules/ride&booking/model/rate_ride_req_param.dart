import 'rating.dart';

class RateRideReqParam {
  final String rideId;
  final List<Rating> ratings;

  RateRideReqParam({required this.rideId, required this.ratings});

  factory RateRideReqParam.fromJson(Map<String, dynamic> json) {
    var ratingsFromJson = json['ratings'] as List;
    List<Rating> ratingsList = ratingsFromJson.map((i) => Rating.fromJson(i)).toList();

    return RateRideReqParam(
      rideId: json['rideId'],
      ratings: ratingsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratings': ratings.map((rating) => rating.toJson()).toList(),
    };
  }
}