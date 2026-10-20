import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/button/button_widget.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/app/widget/app_logo.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/select_signin_method_screen.dart';

import '../../core/theme/app_gap.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/3.png',
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Gap.w4,
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Gap.w4,
                        Container(
                          width: 28,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primarybutton,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
        
                    // Skip button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectSigninMethodScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Skip'.tr(),
                        style: AppText.mdSemiBold_16_700.copyWith(
                          color: AppColors.primarybutton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 160,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/Slide 3.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  //AppLogo(),
                  
                  Positioned(
                    top: 430,
                    left: 0,
                    right: 0,
                    height: 130,
                    child: AppLogo(),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Hoplift!!'.tr(),
                              textAlign: TextAlign.center,
                              // style: AppText.xxxlSemiBold_40_700.copyWith(
                              //   color: AppColors.primaryTextblack,
                              // ),
                              style: TextStyle(
                                color: AppColors.primaryTextblack,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1,
                                letterSpacing: -2,
                              ),
                            ),
                            Gap.h32,
                            context.primaryButton(
                              width: double.infinity,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectSigninMethodScreen(),
                                  ),
                                );
                              },
                              text: "Next",
                            ),
                          ],
                        ),
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
