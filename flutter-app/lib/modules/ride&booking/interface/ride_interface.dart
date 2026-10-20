import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider_joined_state.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider_left_state.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/filter_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/join_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/create_ride_req_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/rate_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

import '../../../core/common/model/rider.dart';
import '../model/booking.dart';
import '../model/change_baggage_req_param.dart';
import '../model/join_ride_req_response.dart';
import '../model/update_ride_req_param.dart';
import '../model/vote_for_kick_req_param.dart';

abstract base class RideInterface extends BaseRepository {
  /// Create a ride
  ///
  /// [params] - The ride parameters
  ///
  /// Returns a Future containing a Success object with a RideModel
  FutureRequest<Success<RideModel>> createRide(CreateRideReq params);

  /// Update a ride
  ///
  /// [params] - The updated ride parameters
  ///
  /// Returns a Future containing a Success object with a RideModel
  FutureRequest<Success<RideModel>> updateRide(UpdateRideReqParam params);

  /// Leave a ride
  ///
  /// [rideId] - The ride to leave
  ///
  /// Returns a Future containing a Success object
  FutureRequest<Success> leaveRide({required String rideId});

  /// Filter rides
  ///
  /// [params] - The filter parameters
  ///
  /// Returns a Future containing a Success object with a List of RideModels
  FutureRequest<Success<List<RideModel>>> filterRide({required FilterRideReqParam params});

  /// Get a ride by id
  ///
  /// [rideId] - The ride id
  ///
  /// Returns a Future containing a Success object with a RideModel
  FutureRequest<Success<RideModel>> getRideById({required String rideId});

  /// Join a ride
  ///
  /// [param] - The join parameters
  ///
  /// Returns a Future containing a Success object with a RideModel
  FutureRequest<Success<JoinRideReqResponse>> joinRide({required JoinRideReqParam param});

  /// Finish a ride
  ///
  /// [rideId] - The ride to finish
  ///
  /// Returns a Future containing a Success object
  FutureRequest<Success> finishRide({required String rideId});

  /// Vote for kicking a user from a ride
  ///
  /// [param] - The vote parameters
  ///
  /// Returns a Future containing a Success object
  FutureRequest<Success<RideModel>> voteForKick({required VoteForKickReqParam param});

  FutureRequest<Success> deleteRide({required String rideId});

  FutureRequest<Success> rateRide({required RateRideReqParam param});

  Stream<RiderJoinedState> riderJoinedStream();

  Stream<RiderLeftState> riderLeftStream();

  FutureRequest<Success> changeBaggage(ChangeBaggageReqParam param);

}