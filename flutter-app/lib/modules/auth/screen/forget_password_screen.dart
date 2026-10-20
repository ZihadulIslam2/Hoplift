import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/create_new_password_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/verify_code_screen.dart';

import '../../../core/common/widgets/reactive_buttons/save_button.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../controller/forget_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;
  late ForgetPasswordController forgetPasswordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    forgetPasswordController = ForgetPasswordController(
      SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 80),
        padding: const EdgeInsets.all(24.0),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap.h16,
                          Text(
                            "Forgot Password",
                            style: AppText.xxxlSemiBold_32_600.copyWith(
                              color: AppColors.primaryTextblack,
                              fontSize: 28,
                            ),
                          ),
                          Gap.h8,
                          Text(
                            "Select verification method and we will send verification code",
                            style: AppText.mdMedium_16_500.copyWith(
                              color: AppColors.secondaryTextblack,
                              height: 1.4,
                            ),
                          ),
                          Gap.h32,
                            
                          /// Email card
                          Container(
                            width: size.width * .95,
                            height: size.height * .12,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.textFieldBorder,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                ),
                                Container(
                                  width: size.width * .15,
                                  height: size.width * .15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryTextblack,
                                    size: 35,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          ' Email',
                                          style: TextStyle(
                                            color: AppColors.primaryTextblack,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextField(
                                          controller: emailController,
                                          style: const TextStyle(
                                            color: AppColors.primaryTextblack,
                                            fontSize: 18,
                                          ),
                                          onChanged: (value) {
                                            forgetPasswordController.email =
                                                value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Enter your email",
                                            hintStyle: const TextStyle(
                                              color: AppColors.primaryTextblack,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 0,
                                                  vertical: 0,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.white24,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        
                  /// Button
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: RSaveButton(
                        key: UniqueKey(),
                        width: double.infinity,
                        height: 54,
                        buttonStatusNotifier:
                            forgetPasswordController.processNotifier,
                        saveText: "Send OTP",
                        loadingText: "Sending...",
                        doneText: "Done",
                        onDone: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerifyCodeScreen.forgetPassword(
                                key: UniqueKey(),
                                email: emailController.text.trim(),
                                onDone: () {
                                  Navigator.maybePop(context).then((_) {
                                    if(context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateNewPasswordScreen(email: forgetPasswordController.email,),
                                        ),
                                      );
                                    }
                                  });
                                  
                                },
                              ),
                            ),
                          );
                        },
                        onSaveTap: () async {
                          await forgetPasswordController.forgetPassword(
                              buttonNotifier:
                                  forgetPasswordController.processNotifier,
                              snackbarNotifier:
                                  forgetPasswordController.snackbarNotifier,
                            );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
