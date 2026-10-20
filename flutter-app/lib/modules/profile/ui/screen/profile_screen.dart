import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/cache/smart_network_image.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_gap.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/bottomsheets/confirm_action_bottomsheet.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/profile_data_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/interface/profile_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/change_password_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/faq_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/help_center_screen.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/ui/screen/language_screen.dart';
import 'package:ttrueno_fo827e642a0c4/app/init_dependency.dart';
import 'edit_profile_info_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileDataController profileDataController;

  bool _notificationEnabled = true;
  String selectedLanguage = '...';

  @override
  void initState() {
    super.initState();
    profileDataController = Get.find<ProfileDataController>();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';

    final languageMap = {
      'en': 'English',
      'fr': 'Français (French)',
      'es': 'Español (Spanish)',
    };

    setState(() {
      selectedLanguage = languageMap[localeCode] ?? 'English';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'My Profile'.tr(),
          style: AppText.xl2Medium_22_500.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ObxValue(
                (data)=> Row(
                  children: [
                    Stack(
                      children: [
                        SmartNetworkImage.circle(
                          key: UniqueKey(),
                          diameter: 96,
                          imageUrl:
                              profileDataController.userProfile.value?.imageUrl,
                          placeholder: Icon(
                            Icons.person_2_outlined,
                            size: 100,
                            color: AppColors.secondaryText,
                          ),
                          errorWidget: Icon(
                            Icons.person_2_outlined,
                            size: 100,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    Gap.w16,
                    Flexible(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if((profileDataController.userProfile.value?.name ?? "").isNotEmpty) FittedBox(
                            child: Text(
                              profileDataController.userProfile.value?.name ?? "",
                              style: AppText.xxlSemiBold_24_600.copyWith(
                                color: AppColors.primaryTextblack,
                              ),
                            ),
                          ),
                          
                          if((profileDataController.userProfile.value?.phoneNumber ?? "").isNotEmpty) FittedBox(
                            child: Text(
                              profileDataController.userProfile.value?.phoneNumber ?? "",
                              style: AppText.mdRegular_16_400.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                          
                          if((profileDataController.userProfile.value?.email ?? "").isNotEmpty) FittedBox(
                            child: Text(
                              profileDataController.userProfile.value?.email ?? "",
                              style: AppText.mdRegular_16_400.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                profileDataController.userProfile
              ),
              const SizedBox(height: 32),

              // Profile Options
              _buildProfileOption(
                context,
                icon: Icons.person_2_outlined,
                title: 'Account info'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileInfoScreen(),
                    ),
                  );
                },
              ),
              Gap.h8,

              // Language Option
              _buildProfileOption(
                context,
                icon: Icons.language,
                title: 'Language'.tr(),
                trailingText: selectedLanguage,
                textColor: AppColors.primaryTextblack,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageSelectionScreen.general(),
                    ),
                  );

                  if (result != null && result is String) {
                    setState(() {
                      selectedLanguage = result;
                    });

                    if(context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Language changed to $result',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                },
              ),

              Gap.h8,

              _buildProfileOption(
                context,
                icon: Icons.lock_outline,
                title: 'Change Password'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),

              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 16),

              _buildProfileOption(
                context,
                icon: Icons.help_outline,
                title: 'FAQs'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqScreen()),
                  );
                },
              ),
              Gap.h8,
              _buildProfileOption(
                context,
                icon: Icons.support_agent_outlined,
                title: 'Help Center'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpCenterPage(),
                    ),
                  );
                },
              ),
              // Gap.h8,
              // _buildProfileOption(
              //   context,
              //   icon: Icons.star_border,
              //   title: 'Rate Us'.tr(),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const SplashScreen(),
              //       ),
              //     );
              //   },
              // ),

              Gap.h32,
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => ConfirmActionBottomSheet(
                        message: 'Are you sure you want to logout?'.tr(),
                        onConfirm: () async {
                          serviceLocator<ProfileInterface>().logout();
                        },
                        confirmStn: ProcessStatusNotifier(initialStatus: EnabledStatus()),
                        confirmButtonText: 'Logout'.tr(),
                        cancelButtonText: 'Not Now'.tr(),
                        height: 200,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Logout'.tr(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    bool isToggle = false,
    bool toggleValue = false,
    ValueChanged<bool>? onToggleChanged,
    VoidCallback? onTap,
    Color textColor = AppColors.primaryTextblack,
    Color iconColor = AppColors.primaryTextblack,
    Color arrowColor = AppColors.primaryTextblack,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            if (isToggle)
              Switch(
                value: toggleValue,
                onChanged: onToggleChanged,
                activeColor: AppColors.primarybutton,
              )
            else
              Icon(Icons.arrow_forward_ios, size: 20, color: arrowColor),
          ],
        ),
      ),
    );
  }
}
