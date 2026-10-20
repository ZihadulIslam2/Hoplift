import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/constants/assets.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/helpers/url_launch.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  

  void _openSocial(String platform) {
    switch (platform) {
      case 'Instagram':
        launchURL(
          Uri.parse('instagram://user?username=hopliftapp'),
          Uri.parse('https://www.instagram.com/hopliftapp/'),
        );
        break;
      case 'TikTok':
        launchURL(
          Uri.parse('tiktok://user?username=hopliftapp'),
          Uri.parse('https://www.tiktok.com/@hopliftapp'),
        );
        break;
      case 'Twitter':
        launchURL(
          Uri.parse('twitter://user?screen_name=Hopliftapp'),
          Uri.parse('https://x.com/Hopliftapp'),
        );
        break;
    }
  }

  Widget buildButton({
    required BuildContext context,
    required Widget icon,
    required String title,
    required Color color,
  }) {
    return InkWell(
      onTap: () => _openSocial(title),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 16),
            Text(
              title,
              style: AppText.mdSemiBold_16_600.copyWith(
                color: AppColors.primaryTextblack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Help Center',
          style: AppText.lgMedium_18_500.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: AppColors.background,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildButton(
              context: context,
              icon: Image.asset(
                Assets.instagram,
                width: 24, height: 24,
              ),
              title: 'Instagram',
              color: AppColors.primarybutton,
            ),
            buildButton(
              context: context,
              icon: Icon(Icons.tiktok),
              title: 'TikTok',
              color: AppColors.primarybutton,
            ),
            buildButton(
              context: context,
              icon: Image.asset(
                Assets.twitter,
                width: 24, height: 24,
              ),
              title: 'Twitter',
              color: AppColors.primarybutton,
            ),
          ],
        ),
      ),
    );
  }
}
