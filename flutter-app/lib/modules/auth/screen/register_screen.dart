import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/save_button.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/controller/sign_up_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/description_doc_view.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/select_signin_method_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/signin_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/verify_code_screen.dart';
import 'package:ttrueno_fo827e642a0c4/app/widget/custom_text_field_widget.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/description_docs_loader.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gap.dart';
import '../../../core/theme/text_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final SignUpController signupController;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _agreedToTerms = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signupController = SignUpController(SnackbarNotifier(context: context));

  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Register",
                                style: AppText.xxxlSemiBold_32_600.copyWith(
                                  color: AppColors.primaryText,
                                ),
                              ),
                              Gap.h8,
                              Text(
                                "Create account and enjoy all services.",
                                style: AppText.smRegular_14_400.copyWith(
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ],
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
                                "Username",
                                style: AppText.mdSemiBold_16_600.copyWith(
                                  color: AppColors.primaryTextblack,
                                ),
                              ),
                              Gap.h8,
                              ReusableTextField(
                                hintText: "Type your username",
                                prefix: Icons.person_2_outlined,
                                controller: usernameController,
                                onChanged: (value) {
                                  debugPrint("Username: $value");
                                  signupController.name = value.trim();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username is required';
                                  }
                                  return null;
                                }, obscureText: false,
                              ),
                              Gap.h16,
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
                                  signupController.email = value.trim();
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
                                }, obscureText: false,
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
                                  signupController.password = value.trim();
                                },
                                validator: (value) {
                                  if (value == null || value.length < 6) {
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
                            ],
                          ),
                          Gap.h24, // Added some gap before the checkbox
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24.0, // Adjust size as needed
                                  height: 24.0, // Adjust size as needed
                                  child: Checkbox(
                                    value: _agreedToTerms,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        _agreedToTerms = newValue!;
                                      });
                                    },
                                    activeColor: AppColors
                                        .primaryTextblack, // Or your preferred color
                                    checkColor: Colors.white,
                                    materialTapTargetSize: MaterialTapTargetSize
                                        .shrinkWrap, // To reduce extra padding
                                  ),
                                ),
                                Gap.w8,
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "I agree to the company ",
                                      style: AppText.smRegular_14_400.copyWith(
                                        color: AppColors.secondaryText,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Term of Service",
                                          style: AppText.smRegular_14_400
                                              .copyWith(
                                                color:
                                                    AppColors.primaryTextblack,
                                              ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DescriptionDocView(descriptionScreenType: DescriptionViewType.termsAndCondition, descriptionText: Get.find<DescriptionDocsLoader>().descriptionDocs?.termsAndCondition ?? "",),
                                                ),
                                              );
                                            },
                                        ),
                                        TextSpan(
                                          text: " and ",
                                          style: AppText.smRegular_14_400
                                              .copyWith(
                                                color: AppColors.secondaryText,
                                              ),
                                        ),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: AppText.smRegular_14_400
                                              .copyWith(
                                                color:
                                                    AppColors.primaryTextblack,
                                              ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DescriptionDocView(descriptionScreenType: DescriptionViewType.privacyPolicy, descriptionText: Get.find<DescriptionDocsLoader>().descriptionDocs?.privacyPolicy ?? "",),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gap.h80,
                          RSaveButton(
                            key: UniqueKey(),
                            width: double.infinity,
                            height: 52,
                            buttonStatusNotifier: signupController.processNotifier,
                            saveText: "Register",
                            loadingText: "Registering...",
                            doneText: "Done",
                            onDone: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyCodeScreen.verifyAccount(
                                      email: emailController.text.trim(),
                                      onDone: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SelectSigninMethodScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                            },
                            onSaveTap: () async{
                              if (_formKey.currentState!.validate() &&
                                  _agreedToTerms) {
                                await signupController.signup(
                                  buttonNotifier: signupController.processNotifier,
                                  snackbarNotifier: signupController.snackbarNotifier,
                                );
                              } else if (!_agreedToTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'You must agree to the Terms of Service and Privacy Policy.',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),

                          Gap.h40,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Do you already have an account? ",
                                style: AppText.smRegular_14_400.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Log in",
                                  style: AppText.smRegular_14_400.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap.h40
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
