import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/button/button_widget.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/modules/auth/screen/select_signin_method_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/onboarding/onboarding3.dart';

import '../../core/theme/app_gap.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/2.png',
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
                          width: 28,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primarybutton,
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
                      ],
                    ),
        
                    // Skip button
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectSigninMethodScreen()),
                        );
                      },
                      child: Text(
                        'Skip',
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
                    top: 50,
                    left: 0,
                    right: 0,
                    //height: 580,
                    child: Image.asset(
                      'assets/images/Slide 2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                          )]
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Share the Ride\nSplit the Cost',
                              textAlign: TextAlign.center,
                              // style: AppText.xxxlSemiBold_40_700.copyWith(
                              //   color: AppColors.primaryTextblack,
                              //   height: 1
                              // ),
                              style: TextStyle(
                                color: AppColors.primaryTextblack,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1,
                                letterSpacing:-2
                              ),
                            ),
                            Gap.h32,
                            context.primaryButton(
                              width: double.infinity,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OnboardingScreen3(),
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
        
              )
              
              
            ),
          ],
        ),
      ),
    );
  }
}
