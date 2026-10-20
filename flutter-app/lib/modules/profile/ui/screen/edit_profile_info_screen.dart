import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/cache/smart_network_image.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/circle_shape.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/save_button.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/button_status_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/textfields/text_field.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/controller/edit_profile_info_controller.dart';

class EditProfileInfoScreen extends StatefulWidget {
  const EditProfileInfoScreen({super.key});

  @override
  State<EditProfileInfoScreen> createState() => _EditProfileInfoScreenState();
}

class _EditProfileInfoScreenState extends State<EditProfileInfoScreen> {
  final controller = Get.put(EditProfileInfoController());
  final ProcessStatusNotifier processNotifier = ProcessStatusNotifier(initialStatus: EnabledStatus(),);
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Get.delete<EditProfileInfoController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Account Info',
          style: AppText.lgMedium_18_500.copyWith(
            color: AppColors.primaryTextblack,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Obx(() {
                  Widget avatar;
                  if (controller.profileImage.value?.path != null) {
                    avatar = CircleShape(
                      backgroundColor: Colors.black,
                      borderColor: Colors.black,
                      child: Image.file(
                        controller.profileImage.value!,
                        height: 96,
                        width: 96,
                        fit: BoxFit.contain,
                      )
                    );
                  } else if (controller.beforeUserProfile?.imageUrl != null) {
                    avatar = SmartNetworkImage.circle(
                      imageUrl: controller.beforeUserProfile!.imageUrl,
                      diameter: 96,
                      errorWidget: Icon(
                        Icons.person,
                        size: 96,
                      ),
                    );
                  } else {
                    avatar = CircleShape(
                      backgroundColor: Colors.grey,
                      child: SizedBox(
                        height: 96,
                        width: 96,
                        child: Icon(Icons.person, color: AppColors.secondaryText, size: 48),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      avatar,
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primarybutton,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 32),

              BuildTextField(
                controller: controller.fullNameController,
                labelText: 'Full Name',
                textColor: AppColors.primaryTextblack,
              ),
              const SizedBox(height: 16),

              BuildTextField(
                controller: controller.emailController,
                labelText: 'Email',
                textColor: AppColors.primaryTextblack,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              BuildTextField(
                controller: controller.phoneController,
                labelText: 'Phone',
                textColor: AppColors.primaryTextblack,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 300),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: RSaveButton(
                  key: UniqueKey(),
                  saveText: "Save",
                  loadingText: "Saving...",
                  doneText: "Done",
                  onSaveTap: () {
                    controller.saveProfile(
                      buttonNotifier: processNotifier,
                      snackbarNotifier: SnackbarNotifier(context: context),
                    );
                  },
                  onDone: () {
                    
                  },
                  buttonStatusNotifier: processNotifier,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
