import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/failure.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/handle_fold.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/interface/notification_interface.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier();

  RxBool isLoading = false.obs;
  RxnString unreadCountString = RxnString();
  int _unReadCount = 0;

  NotificationController() {
    getAllNotification();
  }

  void incrementCount() {
    _unReadCount++;
    unreadCountString.value = _unReadCount.toString();
  }

  void _decrementCount({int? count}) {
    if (count != null) {
      _unReadCount = count;
    } else {
      _unReadCount--;
    }
    
    _unReadCount = _unReadCount < 0 ? 0 : _unReadCount;
    unreadCountString.value = _unReadCount <= 0 ? null : _unReadCount.toString();
  }

  Future<bool> markAsRead(int index) async {
    if (index < 0 || index >= notifications.length) return false;

    final old = notifications[index];
    if (old.isRead) return false;

    final lr = await serviceLocator<NotificationInterface>()
        .singleNotificationRead(old.id);

    return lr.fold(
      (error) {
        return false;
      },
      (success) {
        notifications[index] = old.copyWith(
          isRead: true,
          updatedAt: DateTime.now(),
        );
        notifications.refresh();
        _decrementCount();
        return true;
      },
    );
  }

  Future<void> readAllNotification() async {
    final lr = await serviceLocator<NotificationInterface>()
        .allNotificationRead();

    lr.fold(
      (error) {
        debugPrint("error >> ${error.toString()}");
      },
      (success) {
        for (var i = 0; i < notifications.length; i++) {
          final n = notifications[i];
          if (!n.isRead) {
            notifications[i] = n.copyWith(
              isRead: true,
              updatedAt: DateTime.now(),
            );
          }
          notifications.refresh();
          _decrementCount(count: 0);
          update();
        }
      },
    );
  }

  void toggleExpand(int index) {
    notifications.refresh();
  }

  void markAsReadById(String id) {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      markAsRead(idx);
      _decrementCount();
    }
  }

  Future<void> getAllNotification() async {
    processStatusNotifier.setLoading();
    isLoading.value = true;
    await serviceLocator<NotificationInterface>().getAllNotification().then((
      lr,
    ) {
      handleFold(
        either: lr,
        processStatusNotifier: processStatusNotifier,
        onError: (error) {
          debugPrint("error >> ${error.toString()}");
          if (error.failure == Failure.forbidden) ();
        },
        onSuccess: (data) {
          notifications.value = data;
          _unReadCount = data.where((n) => !n.isRead).length;
          unreadCountString.value = _unReadCount <= 0 ? null : _unReadCount.toString();
          notifications.refresh();
          update();
        },
      );
    });
    isLoading.value = false;
  }
}
