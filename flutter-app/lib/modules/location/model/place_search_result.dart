// domain/entities/place_search_result.dart
import '../../../core/common/model/coordinate.dart';

class PlaceDetails {
  final String placeId;
  final String description;
  final Coordinate coordinate;

  PlaceDetails({
    required this.placeId,
    required this.description,
    required this.coordinate,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final loc = json["location"];
    return PlaceDetails(
      placeId: json["id"] ,
      description: json["formattedAddress"] ?? "No data",
      coordinate: Coordinate(
        latitude: loc["latitude"],
        longitude: loc["longitude"],
      ),
    );
  }

//   factory PlaceDetails.fromPredictionAndDetails(
//     Map<String, dynamic> prediction,
//     Map<String, dynamic> details,
//   ) {
//     final loc = details["geometry"]["location"];
//     return PlaceDetails(
//       placeId: prediction["place_id"],
//       description: prediction["description"] ?? prediction["structured_formatting"]["main_text"] ?? "",
//       coordinate: Coordinate(latitude: loc["lat"], longitude: loc["lng"]),
//     );
//   }
}
