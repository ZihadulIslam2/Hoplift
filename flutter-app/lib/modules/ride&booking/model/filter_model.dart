

import 'package:flutter/foundation.dart';

class FilterModel {
  final num departureFlexMinutes;
  final num arrivalFlexKm;
  final num departureFlexKm;

  FilterModel({
    required this.arrivalFlexKm,
    required this.departureFlexKm,
    required this.departureFlexMinutes,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    try {
      return FilterModel(
        arrivalFlexKm: json["arrivalFlexKm"] as num,
        departureFlexKm: json["departureFlexKm"] as num,
        departureFlexMinutes: json["departureFlexMinutes"] as num,
      );
    } catch (e) {
      debugPrint("FilterModel.fromJson error: $e, json: $json");
      rethrow;
    }
  }

  static FilterModel? tryfromJson(Map<String, dynamic> json) {
    try {
      return FilterModel(
        arrivalFlexKm: json["arrivalFlexKm"] as num,
        departureFlexKm: json["departureFlexKm"] as num,
        departureFlexMinutes: json["departureFlexMinutes"] as num,
      );
    } catch (e) {
      debugPrint("FilterModel.fromJson error: $e, json: $json");
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "arrivalFlexKm": arrivalFlexKm,
      "departureFlexKm": departureFlexKm,
      "departureFlexMinutes": departureFlexMinutes,
    };
  }
}
