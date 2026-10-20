import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/controller/verify_account_view_controller.dart';
import '../../../core/common/widgets/reactive_buttons/save_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gap.dart';
import '../../../core/theme/text_style.dart';

enum _VerifyCodeType { verifyAccount, forgetPassword }

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final VoidCallback onDone;
  final _VerifyCodeType type;
  const VerifyCodeScreen._({
    super.key,
    required this.email,
    required this.onDone,
    required this.type,
  });

  factory VerifyCodeScreen.verifyAccount({
    required String email,
    required VoidCallback onDone,
    Key? key,
  }) {
    return VerifyCodeScreen._(
      key: key,
      email: email,
      onDone: onDone,
      type: _VerifyCodeType.verifyAccount,
    );
  }

  factory VerifyCodeScreen.forgetPassword({
    required String email,
    required VoidCallback onDone,
    Key? key,
  }) {
    return VerifyCodeScreen._(
      key: key,
      email: email,
      onDone: onDone,
      type: _VerifyCodeType.forgetPassword,
    );
  }

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _otpController = TextEditingController();
  late final VerifyOtpController _verifyAccountViewController;
  int _secondsRemaining = 59;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.type == _VerifyCodeType.verifyAccount) {
      _verifyAccountViewController = VerifyAccountViewController(
        email: widget.email,
        snackbarNotifier: SnackbarNotifier(context: context),
      );
    } else {
      _verifyAccountViewController = VerifyForgetPasswordOtpController(
        email: widget.email,
        snackbarNotifier: SnackbarNotifier(context: context),
      );
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Verify Code",
                        style: AppText.xxxlSemiBold_32_600.copyWith(
                          color: AppColors.primaryTextblack,
                        ),
                      ),
                      Gap.h8,
                      Align(
                        //alignment: Alignment.start,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppText.smRegular_14_400.copyWith(
                              color: AppColors.secondaryText,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Please enter the code we just sent to your email",
                                style: AppText.mdRegular_16_400.copyWith(
                                  color: AppColors.secondaryTextblack,
                                ),
                              ),
                              TextSpan(
                                // "Alberxxx@gmail.com",
                                text: " ${widget.email.replaceFirstMapped(
                                  RegExp(r'(\w{3})\w+@'),
                                  (match) => '${match[1]}xxx@',
                                )}",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap.h24,

                      LayoutBuilder(
                        builder: (context, constraints) {
                          return PinCodeTextField(
                            appContext: context,
                            controller: _otpController,
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            keyboardType: TextInputType.none,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(16),
                              fieldHeight: (constraints.maxWidth / 6) - 4,
                              fieldWidth: (constraints.maxWidth / 6) - 4,
                              activeFillColor: Colors.grey.shade100,
                              inactiveFillColor: Colors.grey.shade100,
                              selectedFillColor: Colors.white,
                              inactiveColor: Colors.grey.shade100,
                              selectedColor: Colors.blue,
                              activeColor: Colors.blue,
                            ),
                            animationDuration: const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            onChanged: (value) {
                              _verifyAccountViewController.otp = value;
                            },
                          );
                        }
                      ),

                      Gap.h8,
                      Text(
                        "Resend code in 00:${_secondsRemaining.toString().padLeft(2, '0')}",
                        style: AppText.smRegular_14_400.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap.h24,
                      RSaveButton(
                        key: UniqueKey(),
                        width: double.infinity,
                        height: 52,
                        buttonStatusNotifier:
                            _verifyAccountViewController.prcessNotifier,
                        saveText: "Verify",
                        loadingText: "Verifying",
                        doneText: "Done",
                        onDone: () {
                          widget.onDone();
                        },
                        onSaveTap: () {
                          if (_otpController.text.trim().length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter the 4-digit code'),
                              ),
                            );
                            return;
                          }
                          _verifyAccountViewController.verify();
                        },
                      ),

                      Gap.h24,

                      // Number Pad (optional if using TextInputType.none)
                      _buildNumberPad(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    final List<String> keys = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      ".",
      "0",
      "⌫",
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final key = keys[index];
        return InkWell(
          onTap: () {
            if (key == "⌫") {
              if (_otpController.text.isNotEmpty) {
                _otpController.text = _otpController.text.substring(
                  0,
                  _otpController.text.length - 1,
                );
              }
            } else if (_otpController.text.length <
                _verifyAccountViewController.otpLength) {
              _otpController.text += key;
            }
            setState(() {});
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: key == "⌫"
                ? const Icon(Icons.backspace_outlined, color: Colors.black)
                : Text(
                    key,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
