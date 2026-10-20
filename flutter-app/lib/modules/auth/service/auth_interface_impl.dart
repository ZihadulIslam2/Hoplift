import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/failure.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/cache/hive_cache_service.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/oauth/o_auth_service.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/interface/auth_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/create_new_password_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/login_entity.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/signup_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/verify_account_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/verify_otp_param.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/hive_keys.dart';
import '../../../core/services/app_pigeon/app_pigeon.dart';
import '../../../core/utils/helpers/format_response_data.dart';
import '../model/forget_password_param.dart';

final class AuthInterfaceImpl extends AuthInterface {
  final AppPigeon appPigeon;
  final OAuthService oAuthService;
  // final HiveCacheService hiveCacheService;

  AuthInterfaceImpl(this.appPigeon, this.oAuthService);

  @override

  Stream<AuthStatus> authStream() {
    return appPigeon.authStream;
  }

  @override
  FutureRequest<Success> login(LoginRequestParams params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.login,
          data: params.toJson(),
        );
        final body = extractBodyData(response);
        debugPrint(body.toString());
        await appPigeon.saveNewAuth(
          saveAuthParams: SaveNewAuthParams(
            uid: body["user"]["_id"] as String,
            accessToken: body["accessToken"] as String,
            refreshToken: body["user"]["refreshToken"] as String,
            data: {
              "userId": body["user"]["_id"] as String? ?? "",
            }
          ),
        );
        //await hiveCacheService.put<bool>(HiveCacheKeys.isFirstTimeLogin, false);
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success>> logout() async {
    return asyncTryCatch(
      tryFunc: () async {
        await appPigeon.logOut();
        return Success(message: "Successful logout.");
      },
    );
  }

  @override
  FutureRequest<Success> signup(SignupParam params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint(params.toJson().toString());
        final response = await appPigeon.post(
          ApiEndpoints.signup,
          data: params.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }
  
  
  @override
  FutureRequest<Success> forgetPassword(ForgetPasswordParam param) async {
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.forgetPassword,
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> verifyAccount(VerifyAccountParam params) async {
    debugPrint(params.toMap().toString());
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.registerVerify,
          data: params.toMap(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success> verifyCode(VerifyOtpParam param) async{
    return await asyncTryCatch(
      tryFunc: () async {
        final response = await appPigeon.post(
          ApiEndpoints.verifyCode,
          data: param.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }
  
  @override
  FutureRequest<Success> createNewPassword(CreateNewPasswordParam params) async{
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint(params.toJson().toString());
        final response = await appPigeon.post(
          ApiEndpoints.createNewPassword,
          data: params.toJson(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }
  
  @override
  FutureRequest<Success<AuthStatus>> getCurrentAuth() async{
    return await asyncTryCatch(tryFunc: ()async{
      final authStatus = await appPigeon.currentAuth();
      return Success(message: "", data: authStatus);
    });
  }
  
  @override
  FutureRequest<Success> googleLogin() async{
    return await asyncTryCatch(tryFunc: () async{
      return oAuthService.loginWithGoogle();
    });
  }
  
  @override
  FutureRequest<Success> facebookLogin() async{
    return await asyncTryCatch(tryFunc: () async{
      return oAuthService.loginWithFacebook();
    });
  }
  
  @override
  FutureRequest<Success<bool>> isFirstTimeLogin() async{
    throw UnimplementedError();
    // return asyncTryCatch(tryFunc: () async{
    //   //final isFirstTimeLogin = await hiveCacheService.get<bool>("isFirstTimeLogin");
    //   return Success(message: "", data: isFirstTimeLogin ?? true);
    // });
  }
}
