import 'package:dartz/dartz.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/failure.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/create_new_password_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/signup_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/verify_account_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/verify_otp_param.dart';
import '../../../core/services/app_pigeon/app_pigeon.dart';
import '../model/forget_password_param.dart';
import '../model/login_entity.dart';

 abstract base class AuthInterface extends BaseRepository{
  FutureRequest<Success> login(LoginRequestParams params);

  FutureRequest<Success<bool>> isFirstTimeLogin(); 

  FutureRequest<Success> googleLogin();

  FutureRequest<Success> facebookLogin();

  FutureRequest<Success> signup(SignupParam params);
  /// Verify account
  FutureRequest<Success> verifyAccount(VerifyAccountParam params);

  FutureRequest<Success<AuthStatus>> getCurrentAuth();

  Stream<AuthStatus?> authStream();

  FutureRequest<Success> forgetPassword(ForgetPasswordParam email);

  FutureRequest<Success> verifyCode(VerifyOtpParam param);

  FutureRequest<Success> createNewPassword(CreateNewPasswordParam params);
  
  Future<Either<DataCRUDFailure, Success>> logout();
}
