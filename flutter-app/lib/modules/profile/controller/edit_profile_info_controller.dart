import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ttrueno_fo827e642a0c4/app/app_manager.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/auth_role.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/handle_fold.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/app_pigeon/app_pigeon.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/update_profile_model.dart';

import '../../../core/notifiers/button_status_notifier.dart';
import '../../../core/notifiers/snackbar_notifier.dart';
import '../../../app/init_dependency.dart';
import '../interface/profile_interface.dart';
import '../model/update_profile_avatar_param.dart';
import 'profile_data_controller.dart';

class EditProfileInfoController extends GetxController {
  // Text fields
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Profile state
  var profileImage = Rx<File?>(null);
  final beforeUserProfile = Get.find<ProfileDataController>().userProfile.value;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    fullNameController.text = beforeUserProfile?.name ?? "";
    emailController.text = beforeUserProfile?.email ?? "";
    phoneController.text = beforeUserProfile?.phoneNumber ?? "";
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  Future<void> saveProfile({
    required ProcessStatusNotifier? buttonNotifier,
    required SnackbarNotifier? snackbarNotifier
  }) async{
    buttonNotifier?.setLoading();
    return await serviceLocator<ProfileInterface>().updateProfile(
      UpdateProfileParam(
        id: (Get.find<AppManager>().authStatus as Authenticated).auth.userId,
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim()
      )
    ).then((lr) {
      
      handleFold(
        either: lr,
        processStatusNotifier: buttonNotifier,
        successSnackbarNotifier: snackbarNotifier,
        onSuccess: (data) async{
          if(profileImage.value != null) {
            
            await serviceLocator<ProfileInterface>().uploadProfileAvatar(
              UploadProfileAvatarParam(
                userId: (Get.find<AppManager>().authStatus as Authenticated).auth.userId,
                bytes: await profileImage.value!.readAsBytes(),
                fileName: profileImage.value?.path ?? ""
              )
            );
          } else {
            debugPrint("No image selected");
          }
          Get.find<ProfileDataController>().getCurrentUserProfile();
        },  
      );
    });
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}


