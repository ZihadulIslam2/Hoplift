import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/constants/hive_keys.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/cache/hive_cache_service.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/auth_role.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/handle_fold.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/description_docs_loader.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/profile_data_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/search_and_filter_controller.dart';
import '../modules/message/controller/inbox_controller.dart';
import '../core/constants/api_endpoints.dart';
import '../core/notifiers/snackbar_notifier.dart';
import '../core/services/app_pigeon/app_pigeon.dart';
import '../modules/notification/controller/notification_controller.dart';
import 'init_dependency.dart';
import '../main.dart';
import '../modules/auth/interface/auth_interface.dart';
import '../modules/ride&booking/controller/my_booking_controller.dart';
import 'routing/route_names.dart';

class AppManager extends GetxController {
  StreamSubscription? _authStreamSubscription;
  /// Initializes the stream to listen to auth status
  AppManager() {
    Get.put<DescriptionDocsLoader>(DescriptionDocsLoader());
    Get.find<DescriptionDocsLoader>().init();
    _init();
  }

  _init() async{
    // Get initail auth status
    // Wait for splash screen
    await Future.delayed(const Duration(seconds: 2)).then((_) async{
      final lr = await serviceLocator<AuthInterface>().getCurrentAuth();
      handleFold(either: lr, onSuccess: (initialStatus) => _decideRoute(initialStatus),);
      // Start listening to the auth status changes
      _authStreamSubscription = getAuthStream().listen((newStatus) async{
        _decideRoute(newStatus);
      });
    });

    
  }

  _decideRoute(AuthStatus? newAuthStatus) async{
    debugPrint("(In Appmanager)Auth status: $newAuthStatus");
    if(newAuthStatus == _authStatus) return;
    if(newAuthStatus != null) {
      _authStatus = newAuthStatus; 
      if(_authStatus is UnAuthenticated) {
        //navigatorKey.currentState?.pushNamedAndRemoveUntil(RouteNames.login, (route) => false);   
        final isFirstTimeLogin = await HiveCacheService.onboarding().get<bool>(HiveCacheKeys.isFirstTimeLogin) ?? true;
        debugPrint("isFirstTimeLogin: $isFirstTimeLogin");
        if(isFirstTimeLogin == true) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(RouteNames.onboarding, (route) => false);
        } else {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
        }
      } else if(_authStatus is Authenticated) {
        HiveCacheService.onboarding().put(HiveCacheKeys.isFirstTimeLogin, false);
        await initializeControllers();
        await serviceLocator<AppPigeon>().socketInit(
          SocketConnetParamX(
            token: null,
            socketUrl: ApiEndpoints.socketUrl,
            joinId: (_authStatus as Authenticated).auth.userId,
          )
        );
        navigatorKey.currentState?.pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
      }
      update();
    }
  } 

  @override
  void dispose() {
    _authStreamSubscription?.cancel();
    super.dispose();
  }

  AuthStatus _authStatus = AuthLoading();
  AuthStatus get authStatus => _authStatus;

  Future<void> initializeControllers() async{
    if(Get.isRegistered<SearchRideController>()) {
      await Get.delete<SearchRideController>();
    }
    if(Get.isRegistered<ProfileDataController>()) {
      await Get.delete<ProfileDataController>();
    }
    if(Get.isRegistered<InboxController>()) {
      await Get.delete<InboxController>();
    }
    if(Get.isRegistered<MyBookingControllers>()) {
      await Get.delete<MyBookingControllers>();
    }
    if(Get.isRegistered<NotificationController>()) {
      await Get.delete<NotificationController>();
    }
    
    Get.put(SearchRideController());
    Get.put(NotificationController());
    Get.put(ProfileDataController());
    Get.put(InboxController());
    Get.put(MyBookingControllers());
    
  }

  Stream<AuthStatus?> getAuthStream({SnackbarNotifier? snackbarNotifier}) {
    return serviceLocator<AuthInterface>().authStream();
  }
}
