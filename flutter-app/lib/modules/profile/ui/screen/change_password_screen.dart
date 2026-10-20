import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/app/widget/custom_text_field_widget.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/password_change_success_screen.dart';
import '../../../../core/common/widgets/reactive_buttons/save_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../controller/change_password_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final ChangePasswordController _changePasswordController;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();

    _changePasswordController = ChangePasswordController(
      SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Change Password',
          style: AppText.lgMedium_18_500.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Current Password
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Current Password",
                style: AppText.xlSemiBold_20_600.copyWith(
                  color: AppColors.primaryTextblack,
                ),
              ),
            ),

            Gap.h8,
            ReusableTextField(
              hintText: "Enter current password",
              prefix: Icons.lock_outline,
              obscureText: _obscureCurrent,
              controller: _currentPasswordController,
              onChanged: (value) {
                _changePasswordController.currentPassword = value;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrent
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _obscureCurrent = !_obscureCurrent);
                },
              ),
            ),

            const SizedBox(height: 16),

            // New Password
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "New Password",
                style: AppText.xlSemiBold_20_600.copyWith(
                  color: AppColors.primaryTextblack,
                ),
              ),
            ),

            Gap.h8,
            ReusableTextField(
              hintText: "Enter new password",
              prefix: Icons.lock_outline,
              obscureText: _obscureNew,
              controller: _newPasswordController,
              onChanged: (value) {
                _changePasswordController.newPassword = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter your new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _obscureNew = !_obscureNew);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Confirm Password
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Confirm Password",
                style: AppText.xlSemiBold_20_600.copyWith(
                  color: AppColors.primaryTextblack,
                ),
              ),
            ),
            Gap.h8,
            ReusableTextField(
              hintText: "Re-enter new password",
              prefix: Icons.lock_outline,
              obscureText: _obscureConfirm,
              controller: _confirmNewPasswordController,
              onChanged: (value) {
                _changePasswordController.confirmPassword = value;
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
                  _obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),
            ),
            Spacer(),
            SizedBox(
              height: 52,
              child: RSaveButton(
                key: UniqueKey(),
                width: double.infinity,
                height: 52,
                buttonStatusNotifier: _changePasswordController.processNotifier,
                saveText: "Change Password",
                loadingText: "Changing password...",
                doneText: "Done",
                onDone: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordSuccessScreen(),
                    ),
                  );
                },
                onSaveTap: () {
                  debugPrint("Save tapped");
                  if (true) {
                    _changePasswordController.changePassword(
                      snackbarNotifier:
                          _changePasswordController.snackbarNotifier,
                    );
                  }
                },
              ),
            ),
            Gap.h40,
          ],
        ),
      ),
    );
  }
}
