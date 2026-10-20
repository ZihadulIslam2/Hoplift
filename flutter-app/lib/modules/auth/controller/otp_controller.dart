// import 'package:flutter/material.dart';
// import 'package:ttrueno_fo827e642a0c4/modules/auth/interface/auth_inerface.dart';

// import '../../../core/helpers/handle_fold.dart';
// import '../../../core/notifiers/button_status_notifier.dart';
// import '../../../core/notifiers/snackbar_notifier.dart';
// import '../../../init_dependency.dart';

// abstract class OtpController extends ChangeNotifier {
//   String _email = '';
//   String get email => _email;
//   set email(String value) {
//     if (value != _email) {
//       _email = value;
//       notifyListeners();
//     }
//   }

//   String _otp = '';
//   String get otp => _otp;
//   set otp(String value) {
//     if (value != _otp) {
//       _otp = value;
//       notifyListeners();
//     }
//   }

//   Future<void> verifyOtp({
//     required ProcessStatusNotifier? buttonNotifier,
//     required SnackbarNotifier? snackbarNotifier,
//   });
// }

// class AccountVerificationOtpController extends OtpController {
//   @override
//   Future<void> verifyOtp({
//     required ProcessStatusNotifier? buttonNotifier,
//     required SnackbarNotifier? snackbarNotifier,
//   }) async {
//     buttonNotifier?.setLoading();
//     Future.delayed(const Duration(seconds: 1)).then((_) async {
//       await serviceLocator<AuthInterface>()
//           .(VerifyAccountRequest(email: email, otp: otp))
//           .then((lr) {
//             handleFold(
//               either: lr,
//               processStatusNotifier: buttonNotifier,
//               snackbarNotifier: snackbarNotifier,
//             );
//           });
//     }); // Simulate a delay for loading state
//   }
// }

// class ForgetPasswordOtpController extends OtpController {
//   String _password = '';
//   String get password => _password;
//   set password(String value) {
//     if (value != _password) {
//       _password = value;
//       notifyListeners();
//     }
//   }

//   Future<void> forgotPassword({
//     ProcessStatusNotifier? buttonNotifier,
//     SnackbarNotifier? snackbarNotifier,
//   }) async {
//     buttonNotifier?.setLoading();
//     await serviceLocator<Forgetpassword>()
//         .call(ForgetPasswordParam(email: email))
//         .then((lr) {
//           handleFold(
//             either: lr,
//             processStatusNotifier: buttonNotifier,
//             snackbarNotifier: snackbarNotifier,
//           );
//         });
//   }

//   @override
//   Future<void> verifyOtp({
//     required ProcessStatusNotifier? buttonNotifier,
//     required SnackbarNotifier? snackbarNotifier,
//   }) async {
//     buttonNotifier?.setLoading();
//     Future.delayed(const Duration(seconds: 1)).then((_) async {
//       await serviceLocator<ResetPassword>()
//           .call(
//             ResetPasswordRequest(email: email, otp: otp, password: password),
//           )
//           .then((lr) {
//             handleFold(
//               either: lr,
//               processStatusNotifier: buttonNotifier,
//               snackbarNotifier: snackbarNotifier,
//             );
//           });
//     }); // Simulate a delay for loading state
//   }
// }
