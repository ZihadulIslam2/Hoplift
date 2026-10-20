class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});

  
  @override
  String toString() {
    return 'Coordinate(latitude: $latitude, longitude: $longitude)';
  }
}