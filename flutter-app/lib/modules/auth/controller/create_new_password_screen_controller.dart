import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/handle_fold.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/model/create_new_password_param.dart';

import '../../../core/notifiers/button_status_notifier.dart';
import '../interface/auth_interface.dart';

class CreateNewPasswordScreenController {
  final String email;
  CreateNewPasswordScreenController({required this.email});

  String _newPassword = '';
  String get newPassword => _newPassword;
  set newPassword(String value) {
    _newPassword = value;
    debugPrint("New Password set to: $_newPassword");
  }

  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;
  set confirmPassword(String value) {
    _confirmPassword = value;
    debugPrint("Confirm Password set to: $_confirmPassword");
  }

  bool get isFormValid {
    return _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _newPassword == _confirmPassword;
  }

  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(
    initialStatus: EnabledStatus(),
  );

  void createNewPassword(SnackbarNotifier? snackbarNotifier) async {
    if (isFormValid) {
      processNotifier.setEnabled();
    } else {
      processNotifier.setDisabled();
    }

    await serviceLocator<AuthInterface>()
        .createNewPassword(
          CreateNewPasswordParam(
            email: email,
            newPassword: newPassword,
            confirmNewPassword: confirmPassword,
          ),
        )
        .then((lr) {
          handleFold(
            either: lr,
            processStatusNotifier: processNotifier,
            successSnackbarNotifier: snackbarNotifier,
            errorSnackbarNotifier: snackbarNotifier,
          );
        });
  }
}
