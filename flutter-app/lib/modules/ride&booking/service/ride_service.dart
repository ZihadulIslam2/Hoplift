
import 'package:flutter/foundation.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/model/rider_left_state.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/core/constants/api_endpoints.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/ride_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/change_baggage_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/filter_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/join_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/create_ride_req_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/update_ride_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/vote_for_kick_req_param.dart';

import '../../../core/common/model/rider_joined_state.dart';
import '../../../core/services/app_pigeon/app_pigeon.dart';
import '../../../core/utils/helpers/format_response_data.dart';
import '../model/join_ride_req_response.dart';
import '../model/rate_ride_req_param.dart';

final class RideService extends RideInterface {
  RideService(this.appPigeon);

  final AppPigeon appPigeon;

  @override
  FutureRequest<Success<RideModel>> createRide(CreateRideReq params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint("Sending ride data: ${params.toJson()}");

        final response = await appPigeon.post(
          ApiEndpoints.createRide,
          data: params.toJson(),
        );

        final body = extractBodyData(response)["ride"];
        debugPrint("Ride created response: $body");

        final ride = RideModel.fromJson(body);

        return Success<RideModel>(
          message: extractSuccessMessage(response),
          data: ride,
        );
      },
    );
  }

  @override
  FutureRequest<Success<List<RideModel>>> filterRide({required FilterRideReqParam params}) async{
    debugPrint("Filtering rides with params: ${params.toJson()}");
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.get(
          ApiEndpoints.filterRide,
          query: params.toJson(),
        );
        debugPrint("Filtering rides response: ${extractBodyData(response)}");
        return Success<List<RideModel>>(
          message: extractSuccessMessage(response),
          data: (extractBodyData(response)["rides"] as List<dynamic>).map((e) => RideModel.fromJson(e)).toList(),
        );
      },
    );
  }

  @override
  FutureRequest<Success> finishRide({required String rideId}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.post(
          ApiEndpoints.finishRide(rideId),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success<RideModel>> getRideById({required String rideId}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.post(
          ApiEndpoints.getRideById(rideId)
        );
        return Success(message: extractSuccessMessage(response), data: RideModel.fromJson(extractBodyData(response)));
      },
    );
  }

  @override
  FutureRequest<Success<JoinRideReqResponse>> joinRide({required JoinRideReqParam param}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.post(
          ApiEndpoints.joinRide(param.rideId),
          data: param.toJson(),
        );
          debugPrint("Join ride response: ${extractBodyData(response)}");
        return Success(
          message: extractSuccessMessage(response),
          data: JoinRideReqResponse.fromJson(extractBodyData(response)),
        );
      },
    );
  }

  @override
  FutureRequest<Success> leaveRide({required String rideId}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.post(
          ApiEndpoints.leaveRide(rideId)
        );
        return Success(message: extractSuccessMessage(response),);
      },
    );
  }

  @override
  FutureRequest<Success<RideModel>> updateRide(UpdateRideReqParam params) async{
    return await asyncTryCatch(tryFunc: ()async{
      final response = await appPigeon.put(
        ApiEndpoints.updateRide(params.rideId),
        data: params.toJson(),
      );
      return Success(message: extractSuccessMessage(response), data: RideModel.fromJson(extractBodyData(response)));
    });
  }

  @override
  FutureRequest<Success<RideModel>> voteForKick({required VoteForKickReqParam param}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.post(
          ApiEndpoints.voteForKick(param.rideId),
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response), data: RideModel.fromJson(extractBodyData(response)));
      },
    );
  }
  
  @override
  FutureRequest<Success> deleteRide({required String rideId}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.delete(
          ApiEndpoints.deleteRide(rideId),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  Stream<RiderJoinedState> riderJoinedStream() {
    return appPigeon.listen("userJoined").map((e) => RiderJoinedState.fromJson(e));
  }

  @override
  Stream<RiderLeftState> riderLeftStream() {
    return appPigeon.listen("userLeft").map((e) => RiderLeftState.fromJson(e));
  }
  
  @override
  FutureRequest<Success> rateRide({required RateRideReqParam param}) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.post(
          ApiEndpoints.rateRide(param.rideId),
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> changeBaggage(ChangeBaggageReqParam param) async{
    return asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.patch(
          ApiEndpoints.changeBaggage(param.rideId),
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }
}

