import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/failure.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/handle_fold.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/validation.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';

import '../../../core/notifiers/button_status_notifier.dart';
import '../interface/auth_interface.dart';
import '../model/login_entity.dart';

class LoginsScreenController extends ChangeNotifier {

  final ProcessStatusNotifier processStatusNotifier = ProcessStatusNotifier();
  final SnackbarNotifier snackbarNotifier;
  String _email = '';
  String get email => _email;

  canLogin() {
    if(_email.isNotEmpty && isEmail(_email) && _password.isNotEmpty) {
      processStatusNotifier.setEnabled();
    } else {
      processStatusNotifier.setDisabled();
    }
  }
  set email(String value) {
    if (value != _email) {
      _email = value;
      canLogin();
      notifyListeners();
    }
  }

  String _password = '';

  LoginsScreenController(this.snackbarNotifier);
  String get password => _password;
  set password(String value) {
    if (value != _password) {
      _password = value;
      canLogin();
      notifyListeners();
    }
  }

  Future<void> login({
    required VoidCallback needVerification,
  }) async {
    processStatusNotifier.setLoading();
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      await serviceLocator<AuthInterface>().login(LoginRequestParams.emailLogin(email: email, password: password)).then((lr) {
            handleFold(
              either: lr,
              processStatusNotifier: processStatusNotifier,
              successSnackbarNotifier: snackbarNotifier,
              errorSnackbarNotifier: snackbarNotifier,
              onError: (error) {
                if (error.failure == Failure.forbidden) needVerification();
              },
            );
          });
      });
  }

  Future<void> googleLogin() async{
    processStatusNotifier.setLoading();
    await serviceLocator<AuthInterface>().googleLogin().then((lr) {
        handleFold(
          either: lr,
          processStatusNotifier: processStatusNotifier,
          successSnackbarNotifier: snackbarNotifier,
          //errorSnackbarNotifier: snackbarNotifier,
        );
      });
  }

  Future<void> facebookLogin() async{
    processStatusNotifier.setLoading();
    await serviceLocator<AuthInterface>().facebookLogin().then((lr) {
        handleFold(
          either: lr,
          processStatusNotifier: processStatusNotifier,
          successSnackbarNotifier: snackbarNotifier,
          //errorSnackbarNotifier: snackbarNotifier,
        );
      });
  }
}
