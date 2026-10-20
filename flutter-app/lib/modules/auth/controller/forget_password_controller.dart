import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/interface/auth_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/forget_password_param.dart';
import '../../../core/utils/helpers/handle_fold.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../../../app/init_dependency.dart';

class ForgetPasswordController extends ChangeNotifier {

  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(initialStatus: EnabledStatus());
  final SnackbarNotifier snackbarNotifier;
  ForgetPasswordController(this.snackbarNotifier);

  String _email = '';
  String get email => _email;
  set email(String value) {
    debugPrint("Setting email to $value");
    if (value != _email) {
      _email = value;
      processNotifier.setEnabled();
      notifyListeners();
    }
  }


  Future<void> forgetPassword({required ProcessStatusNotifier? buttonNotifier, required SnackbarNotifier? snackbarNotifier}) async {
    buttonNotifier?.setLoading();
    Future.delayed(const Duration(seconds: 1)).then((_) async{
      await serviceLocator<AuthInterface>()
      .forgetPassword(ForgetPasswordParam(email: email))
      .then((lr) {
          handleFold(
            either: lr,
            processStatusNotifier: buttonNotifier,
            successSnackbarNotifier: snackbarNotifier,
            errorSnackbarNotifier: snackbarNotifier
          );
      });
    }); // Simulate a delay for loading state
  }
}
