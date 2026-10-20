import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';

import 'package:ttrueno_fo827e642a0c4/core/common/model/coordinate.dart';

import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/app_pigeon/app_pigeon.dart';

import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';

import 'package:ttrueno_fo827e642a0c4/modules/location/model/place_prediction.dart';

import 'package:ttrueno_fo827e642a0c4/modules/location/model/place_search_result.dart';

import '../interface/location_interface.dart';

final class LocationService extends LocationInterface{
  final Dio _dio;
  final AppPigeon appPigeon;

  LocationService(this._dio, this.appPigeon);

  static const String _apiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  @override
  FutureRequest<Success<LocationAdress>> getAddressFromLatLng({required Coordinate latLng}) async{
    return await asyncTryCatch(tryFunc: () async{
      return await _dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=${latLng.latitude},${latLng.longitude}&'
        'key=$_apiKey',
      ).then((response) {
        final data = response.data["results"][0];
        final String place = data["formatted_address"] ?? "null";
        debugPrint("Get address from latlng response $place,");
        return Success(data: LocationAdress(lat: latLng.latitude, lng: latLng.longitude, address: place));
      });
    });
  }

  @override
  FutureRequest<Success<Coordinate>> getCurrentLocation() {
    // TODO: implement getCurrentLocation
    throw UnimplementedError();
  }

  @override
  FutureRequest<Success<PlaceDetails>> getPlaceDetails(String placeId) async{
    return await asyncTryCatch(tryFunc: () async{
      final res = await _dio.get(
        'https://places.googleapis.com/v1/places/$placeId',
        queryParameters: {
          'fields': 'id,displayName,formattedAddress,location,rating,photos',
        },

        options: Options(
          headers: {
            'X-Goog-Api-Key': _apiKey,
          },
        ),
      );
      debugPrint("Place details $res");
      return Success(data: PlaceDetails.fromJson(res.data));
    });
  }

  @override
  FutureRequest<Success<List<PlacePrediction>>> searchPlaces({required String query}) async{
    // debugPrint("Search places $query, api key $_apiKey");
    return await asyncTryCatch(tryFunc: () async{
      final autocompleteRes = await _dio.post(
        'https://places.googleapis.com/v1/places:autocomplete',
        data: {
          'input': query,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': _apiKey,
          },
        ),
      );
      // debugPrint("Search places $autocompleteRes");
      final predictions = List<Map<String, dynamic>>.from(
        autocompleteRes.data["suggestions"] ?? [],
      );
      return Success(data: predictions.map((e) => PlacePrediction.fromJson(e)).toList());
    });
  }

}

