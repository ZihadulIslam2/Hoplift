import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/debug/debug_service.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/oauth/o_auth_service.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/service/auth_interface_impl.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/interface/location_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/service/location_service.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/interface/message_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/service/message_service.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/interface/notification_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/service/notification_interface_impl.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/interface/profile_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/service/profile_interface_impl.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/booking_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/interface/ride_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/service/booking_service.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/service/ride_service.dart';
import '../core/constants/api_endpoints.dart';
import '../core/services/app_pigeon/app_pigeon.dart';
import '../core/services/app_pigeon/refresh_token_manager.dart';
import '../modules/auth/interface/auth_interface.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {

  // Initialize Hive manually
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  DebugService.instance(allowsOnly: {DebugLabel.service, DebugLabel.auth, DebugLabel.controller});
  final Dio _dio = Dio();
  final AppPigeon appPigeon = AppPigeon(
    RefreshTokenManager(ApiEndpoints.refreshToken),
    baseUrl: ApiEndpoints.baseUrl,
  );

  serviceLocator.registerFactory<Dio>(()=> _dio);

  serviceLocator.registerFactory<AppPigeon>(()=> appPigeon);

  // final profileCacheService = HiveCacheService.profile();
  // final onboardingCacheService = HiveCacheService.onboarding();

  serviceLocator.registerFactory<OAuthService>(()=> OAuthService(serviceLocator<AppPigeon>()));
  // Dependencies
  serviceLocator.registerFactory<AuthInterface>(
    () => AuthInterfaceImpl(serviceLocator<AppPigeon>(), serviceLocator<OAuthService>()),
  );

  serviceLocator.registerFactory<ProfileInterface>(
    ()=> ProfileInterfaceImpl(serviceLocator<AppPigeon>()),
  );

  serviceLocator.registerFactory<NotificationInterface>(
    ()=> NotificationInterfaceImpl(serviceLocator<AppPigeon>()),
  );

  serviceLocator.registerFactory<RideInterface>(
    ()=> RideService(serviceLocator<AppPigeon>()),
  );
  
  serviceLocator.registerFactory<LocationInterface>(
    ()=> LocationService(Dio(), serviceLocator<AppPigeon>()),
  );

  serviceLocator.registerFactory<MessageInterface>(
    ()=> MessageService(serviceLocator<AppPigeon>()),
  );

  serviceLocator.registerFactory<BookingInterface>(
    ()=> BookingService(serviceLocator<AppPigeon>()),
  );
}
