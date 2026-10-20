import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/core/constants/api_endpoints.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/interface/notification_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/model/notification_model.dart';

import '../../../core/services/app_pigeon/app_pigeon.dart';
import '../../../core/utils/helpers/format_response_data.dart';

final class NotificationInterfaceImpl extends NotificationInterface {
  final AppPigeon appPigeon;

  NotificationInterfaceImpl(this.appPigeon);

  @override
  FutureRequest<Success<List<NotificationModel>>> getAllNotification() async {
    return await asyncTryCatch(
      tryFunc: () async {
        // call api
        final Response response = await appPigeon.get(
          ApiEndpoints.getUserNotifications,
        );
        // parse
        final data = response.data["data"] as List<dynamic>;
        final List<NotificationModel> notifications = [];

        for (int i = 0; i < data.length; i++) {
          notifications.add(NotificationModel.fromJson(data[i]));
        }
        // return
        return Success(
          message: extractSuccessMessage(response),
          data: notifications,
        );
      },
    );
  }

  @override
  FutureRequest<Success> singleNotificationRead(String id) async {
    return await asyncTryCatch(
      tryFunc: () async {
        // call api
        final response = await appPigeon.put(
          ApiEndpoints.markNotificationAsRead(notificationId: id),
        );

        //parse
        final message = response.data['message'] as String;

        //return
        return Success(message: message);
      },
    );
  }

  @override
  FutureRequest<Success> allNotificationRead() async {
    return await asyncTryCatch(
      tryFunc: () async {
        // Call api
        final response = await appPigeon.put(
          ApiEndpoints.readAllNotifications,
        );

        //Parse
        
        //Return
        return Success(
          message: extractSuccessMessage(response),
        );
      },
    );
  }
}
