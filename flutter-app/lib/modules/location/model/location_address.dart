class LocationAdress {
  String? address;
  double? lat;
  double? lng;

  LocationAdress({this.address, this.lat, this.lng});

  factory LocationAdress.fromJson(Map<String, dynamic> json) {
    try {
      return LocationAdress(
        address: json['address'],
        lat: json['lat'],
        lng: json['lng'],
      );
    } catch (e) {
      print('Failed to parse LocationAdress from JSON: $e');
      throw Exception('Failed to parse LocationAdress from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }

  @override
  String toString() {
    return 'LocationAdress(address: $address, lat: $lat, lng: $lng)';
  }
}