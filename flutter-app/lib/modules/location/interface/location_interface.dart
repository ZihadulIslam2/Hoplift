import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';
import '../../../core/base/success.dart';
import '../../../core/common/model/coordinate.dart';
import '../../../core/utils/helpers/typedefs.dart';
import '../model/place_prediction.dart';
import '../model/place_search_result.dart';

abstract base class LocationInterface extends BaseRepository{

  FutureRequest<Success<LocationAdress>> getAddressFromLatLng({required Coordinate latLng});

  FutureRequest<Success<List<PlacePrediction>>> searchPlaces({required String query}); 

  FutureRequest<Success<Coordinate>> getCurrentLocation();

  FutureRequest<Success<PlaceDetails>> getPlaceDetails(String placeId);

}