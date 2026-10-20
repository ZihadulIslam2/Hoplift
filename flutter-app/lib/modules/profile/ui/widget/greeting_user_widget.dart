import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import '../../../../core/theme/app_colors.dart';
import '../../controller/profile_data_controller.dart';

class GreetingUserWidget extends StatelessWidget {
  const GreetingUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileDataController>();
    return Obx(
      ()=> Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Hi".tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextblack,
                ),
              ),
              TextSpan(
                text: ' ',
                style: TextStyle(color: AppColors.primaryTextblack),
              ),
              TextSpan(
                text: '${controller.userProfile.value?.name ?? "User"} 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTextblack,
                ),
              ),
            ],
          ),
        ),
    );
  }
}