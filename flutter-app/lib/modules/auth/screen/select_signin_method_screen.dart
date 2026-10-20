import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/button/button_widget.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/interface/auth_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/register_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/signin_screen.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gap.dart';
import '../../../core/theme/text_style.dart';

class SelectSigninMethodScreen extends StatefulWidget {
  const SelectSigninMethodScreen({super.key});

  @override
  State<SelectSigninMethodScreen> createState() => _SelectSigninMethodScreenState();

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

class _SelectSigninMethodScreenState extends State<SelectSigninMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
          // ),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Explore a new ride sharing experience with Hoplift!",
                            style: AppText.smRegular_14_400.copyWith(
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  ),

                  Gap.h60,

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        context.primaryButton(
                          width: double.infinity,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          text: 'Continue With Email',
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

                        // Social Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () => serviceLocator<AuthInterface>().googleLogin(),
                                child: SelectSigninMethodScreen._socialIcon(
                                  'assets/images/google.png',
                                ),
                              ),
                              Gap.w32,
                              InkWell(
                                onTap: () {
                                  serviceLocator<AuthInterface>().facebookLogin();
                                },
                                child: SelectSigninMethodScreen._socialIcon(
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
                                    builder: (context) => RegisterScreen(),
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
                        Gap.h40
                      ],
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
