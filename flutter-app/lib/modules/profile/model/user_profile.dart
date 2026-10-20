import 'package:flutter/rendering.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String imageUrl;
  final num rating;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.rating, 
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    try {
      return UserProfile(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        imageUrl: json['profileImage'] ?? '',
        rating: json["rating"] ?? 0,
      );
    } catch (e) {
      debugPrint("Error parsing user profile: $e, json: $json");
      throw FormatException("Error parsing user profile: $e");
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'number': phoneNumber,
        'profileImage': imageUrl,
        'rating': rating
      };

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? number,
    String? imageUrl,
    num? rating
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: number ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating
    );
  }
}
