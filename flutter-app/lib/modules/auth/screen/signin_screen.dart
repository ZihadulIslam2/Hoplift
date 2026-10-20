import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/app/view/bottom_nab_bar_page.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/save_button.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/controller/login_screen_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/interface/auth_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/forget_password_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/register_screen.dart';
import 'package:ttrueno_fo827e642a0c4/app/widget/custom_text_field_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gap.dart';
import '../../../core/theme/text_style.dart';
import 'verify_code_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static Widget _socialIcon(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Image.asset(assetPath, width: 24, height: 24),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final LoginsScreenController _loginsScreenController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscure = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginsScreenController = LoginsScreenController(
      SnackbarNotifier(context: context),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign in to your account",
                          style: AppText.xxxlSemiBold_32_600.copyWith(
                            color: AppColors.primaryText,
                          ),
                        ),
                        Gap.h8,
                        Text(
                          "Explore a new ride sharing experience with Hoplift!",
                          style: AppText.smRegular_14_400.copyWith(
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap.h12,
                  Container(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: AppText.mdSemiBold_16_600.copyWith(
                                  color: AppColors.primaryTextblack,
                                ),
                              ),
                              Gap.h8,
                              ReusableTextField(
                                hintText: "Type your email",
                                prefix: Icons.email_outlined,
                                controller: emailController,
                                onChanged: (value) {
                                  _loginsScreenController.email = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  }
                                  final emailRegex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  );
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                                obscureText: false,
                              ),
                              Gap.h16,
                              Text(
                                "Password",
                                style: AppText.mdSemiBold_16_600.copyWith(
                                  color: AppColors.primaryTextblack,
                                ),
                              ),
                              Gap.h8,
                              ReusableTextField(
                                hintText: "Type your password",
                                prefix: Icons.lock_outline,
                                obscureText: _obscure,
                                controller: passwordController,
                                onChanged: (value) {
                                  _loginsScreenController.password = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscure = !_obscure);
                                  },
                                ),
                              ),
                              Gap.h8,
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap.h16,
                          SizedBox(
                            height: 52,
                            child: RSaveButton(
                              height: 50,
                              borderRadius: BorderRadius.circular(20),
                              key: UniqueKey(),
                              buttonStatusNotifier:
                                  _loginsScreenController.processStatusNotifier,
                              saveText: "Log in".tr(),
                              loadingText: "Logging in".tr(),
                              onSaveTap: () async {
                                await _loginsScreenController.login(
                                  needVerification: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyCodeScreen.verifyAccount(
                                          email: emailController.text,
                                          onDone: () {
                                            
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onDone: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNabBarScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),

                          Gap.h40,
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "OR",
                                  style: AppText.mdRegular_16_400.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                          Gap.h40,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => _loginsScreenController.googleLogin(),
                                child: LoginScreen._socialIcon(
                                  'assets/images/google.png',
                                ),
                              ),
                              Gap.w32,
                              InkWell(
                                onTap: () {
                                  _loginsScreenController.facebookLogin();
                                },
                                child: LoginScreen._socialIcon(
                                  'assets/images/facebook.png',
                                ),
                              ),
                            ],
                          ),
                          Gap.h120,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have account? ",
                                style: AppText.smRegular_14_400.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Register",
                                  style: AppText.smRegular_14_400.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap.h40,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
