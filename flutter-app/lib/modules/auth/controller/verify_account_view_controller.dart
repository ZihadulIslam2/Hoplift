import 'package:flutter/foundation.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/interface/auth_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/verify_account_param.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../model/verify_otp_param.dart';

abstract class VerifyOtpController extends ChangeNotifier {
  final AuthInterface authInterface = serviceLocator<AuthInterface>();
  final ProcessStatusNotifier prcessNotifier = ProcessStatusNotifier(
    initialStatus: DisabledStatus(),
  );
  final SnackbarNotifier snackbarNotifier;
  final String email;

  VerifyOtpController({required this.email, required this.snackbarNotifier});

  int otpLength = 6;
  String _otp = "";

  String get otp => _otp;

  set otp(String value) {
    _otp = value;
    debugPrint(_otp);
    if (_otp.length == 6) {
      prcessNotifier.setEnabled();
    } else {
      prcessNotifier.setDisabled();
    }
  }

  void verify();
}


class VerifyAccountViewController extends VerifyOtpController{
  VerifyAccountViewController({required super.email, required super.snackbarNotifier});

  @override
  void verify() async{
    if (prcessNotifier.status is LoadingStatus) return;
    debugPrint("verifying...");
    prcessNotifier.setLoading();
    await authInterface
        .verifyAccount(VerifyAccountParam(email: email, code: otp))
        .then((lr) {
          handleFold(
            either: lr,
            processStatusNotifier: prcessNotifier,
            successSnackbarNotifier: snackbarNotifier,
          );
        });
  }
}

class VerifyForgetPasswordOtpController extends VerifyOtpController{
  VerifyForgetPasswordOtpController({required super.email, required super.snackbarNotifier});

  @override
  void verify() async{
    if (prcessNotifier.status is LoadingStatus) return;
    debugPrint("verifying...");
    prcessNotifier.setLoading();
    await authInterface
        .verifyCode(VerifyOtpParam(email: email, otp: otp))
        .then((lr) {
          handleFold(
            either: lr,
            processStatusNotifier: prcessNotifier,
            successSnackbarNotifier: snackbarNotifier,
            errorSnackbarNotifier: snackbarNotifier,
          );
        });
  }
}