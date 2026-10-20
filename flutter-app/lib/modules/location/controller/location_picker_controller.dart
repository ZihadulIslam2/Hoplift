
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/interface/location_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';

import '../../../core/common/model/coordinate.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../model/place_prediction.dart';

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}

extension LocationExt on Coordinate {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  Coordinate fromLatlngAddress(LatLng latLng, String address) {
    return Coordinate(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
    );
  }
}

typedef OnConfirmLocation = void Function(LocationAdress caa);

class LocationPickerController {
  final OnConfirmLocation onSelect;
  final LocationAdress? initialCoordinateAddress;
  LocationPickerController(this.onSelect, this.initialCoordinateAddress){
    debugPrint("New LocationPickerController");
    if(initialCoordinateAddress != null){
      _setSelectedLocation(initialCoordinateAddress!);
    }
  }

  // Search input
  RxString query = ''.obs;

  // Autocomplete predictions
  var predictions = <PlacePrediction>[].obs;

  // Selected place
  Rx<LocationAdress?> selectedCoordinateAndAddress = Rx<LocationAdress?>(null);

  // Map state

  dispose() {
    // TODO: implement dispose
    query.close();
    predictions.close();
    selectedCoordinateAndAddress.close();
   // mapController?.dispose();
  }

  // Search text handler with debouncer
  void onSearchChanged(String value) {
    query.value = value;
    if (value.isNotEmpty) {
      debounce(query, (_) async {
        final results = await serviceLocator<LocationInterface>().searchPlaces(query: query.value);
        results.fold(
          (failure) => predictions.value = [],
          (list) {
            debugPrint("Search result >> ${list.data?.length}");
            predictions.value = list.data ?? [];
          }
        );
      }, time: const Duration(milliseconds: 500));
    } else {
      predictions.clear();
    }
  }

  // When user taps on prediction
  Future<void> selectPrediction(PlacePrediction prediction) async {
    debugPrint("Selected prediction >> ${prediction.description}");
    final details = await serviceLocator<LocationInterface>().getPlaceDetails.call(prediction.placeId);
    handleFold(
      either: details,
      onError: (failure) {
        debugPrint("Error >> ${failure.fullError}");
      },
      onSuccess: (place) {
        debugPrint("Selected place >> ${place.description}");
        _setSelectedLocation(
          LocationAdress(
            lat: place.coordinate.latitude,
            lng: place.coordinate.longitude,
            address: place.description,
          ),
        );
        predictions.clear();
      },
    );
  }

  Future<void> getAndSetLocationFromLatLng({required Coordinate location, bool confirm = false}) async{
    await serviceLocator<LocationInterface>().getAddressFromLatLng(latLng: location).then((lr) {
      handleFold(
        either: lr,
        onSuccess: (coordinateAndAddress) {
          _setSelectedLocation(coordinateAndAddress);
          if(confirm && selectedCoordinateAndAddress.value != null) {
            onSelect(selectedCoordinateAndAddress.value!);
          }
        }
      );
    });
  }

  void _setSelectedLocation(LocationAdress coordinateAndAddress) {
    selectedCoordinateAndAddress.value = coordinateAndAddress;
    debugPrint("Selected location >> ${coordinateAndAddress.address}");
    onSelect(coordinateAndAddress);
  }

}
