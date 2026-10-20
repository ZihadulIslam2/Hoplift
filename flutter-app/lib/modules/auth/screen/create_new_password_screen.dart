import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/save_button.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/password_change_success_screen.dart';
import 'package:ttrueno_fo827e642a0c4/app/widget/custom_text_field_widget.dart';

import '../controller/create_new_password_screen_controller.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  const CreateNewPasswordScreen({super.key, required this.email});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final CreateNewPasswordScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = CreateNewPasswordScreenController(email: widget.email);
  }

  bool _obscurenewpassword = true;
  bool _obscureconfirmnewpassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap.h16,
                            Text(
                              "New Password",
                              style: AppText.xxxlSemiBold_40_700.copyWith(
                                color: AppColors.primaryTextblack,
                                fontSize: 28,
                              ),
                            ),
                            Gap.h8,
                            Text(
                              "Create a new password that is safe and easy to remember",
                              style: AppText.mdRegular_16_400.copyWith(
                                color: AppColors.secondaryTextblack,
                                height: 1.4,
                              ),
                            ),
                            Gap.h32,
                            Text(
                              "New Password",
                              style: AppText.xlSemiBold_20_600.copyWith(
                                color: AppColors.primaryTextblack,
                              ),
                            ),
                            Gap.h8,
                            ReusableTextField(
                              hintText: "New password",
                              prefix: Icons.lock_outline,
                              obscureText: _obscurenewpassword,
                              controller: _newPasswordController,
                              onChanged: (value) {
                                controller.newPassword = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurenewpassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscurenewpassword =
                                        !_obscurenewpassword,
                                  );
                                },
                              ),
                            ),
                            Gap.h24,
                            Text(
                              "Confirm New Password",
                              style: AppText.xlSemiBold_20_600.copyWith(
                                color: AppColors.primaryTextblack,
                              ),
                            ),
                            Gap.h8,
                            ReusableTextField(
                              hintText: "Confirm new password",
                              prefix: Icons.lock_outline,
                              obscureText: _obscureconfirmnewpassword,
                              controller: _confirmPasswordController,
                              onChanged: (value) {
                                controller.confirmPassword = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm your password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureconfirmnewpassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _obscureconfirmnewpassword =
                                        !_obscureconfirmnewpassword,
                                  );
                                },
                              ),
                            ),
                            Gap.h24,
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RSaveButton(
                        key: UniqueKey(),
                        buttonStatusNotifier: controller.processNotifier,
                        saveText: "Update Password",
                        loadingText: "Updating...",
                        doneText: "Done",
                        onSaveTap: () {
                          controller.createNewPassword(
                            SnackbarNotifier(context: context),
                          );
                        },
                        onDone: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordSuccessScreen(),
                            ),
                            (route) => false,
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
