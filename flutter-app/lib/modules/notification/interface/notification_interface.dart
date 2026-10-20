import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/model/notification_model.dart';

abstract base class NotificationInterface extends BaseRepository {
  FutureRequest<Success<List<NotificationModel>>> getAllNotification(
  );

  FutureRequest<Success> singleNotificationRead(String id);

  FutureRequest<Success> allNotificationRead();
}
