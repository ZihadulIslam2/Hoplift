import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/core/constants/api_endpoints.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/interface/profile_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/change_password_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/description_docs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/update_profile_avatar_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/update_profile_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/user_profile.dart';
import '../../../core/services/app_pigeon/app_pigeon.dart';
import '../../../core/utils/helpers/format_response_data.dart';

final class ProfileInterfaceImpl extends ProfileInterface {
  final AppPigeon appPigeon;

  ProfileInterfaceImpl(this.appPigeon);

  @override
  FutureRequest<Success> changePassword(ChangePassowrdParam params) async {
    return await asyncTryCatch(
      tryFunc: () async {
        debugPrint("ChangePassword Request: ${params.toJson()}");

        final response = await appPigeon.post(
          ApiEndpoints.changePassword,
          data: params.toJson(),
        );

        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success<UserProfile>> getUserProfilebyId(String id) async {
    return await asyncTryCatch(
      tryFunc: () async {
        //response
        final response = await appPigeon.get(ApiEndpoints.getuserbyId(id));

        //parse
        final data = response.data["data"] as Map<String, dynamic>;
        final UserProfile userProfile = UserProfile.fromJson(data);

        var message = response.data['message'] as String;


        //return

        return Success(message: message, data: userProfile);

      },
    );
  }

  @override
  FutureRequest<Success> updateProfile(UpdateProfileParam params) async{
    return await asyncTryCatch(tryFunc: () async{
      final response = await appPigeon.put(
        "${ApiEndpoints.editProfile}/${params.id}",
        data: params.toJson(),
      );
      return Success(message: extractSuccessMessage(response));
    });
  }

  @override
  FutureRequest<Success> uploadProfileAvatar(UploadProfileAvatarParam params) async{
    return await asyncTryCatch(tryFunc: () async{
      final response = await appPigeon.post(
        "${ApiEndpoints.uploadProfileAvatar}/${params.userId}",
        data: await params.toFormData(),
        options: Options(
            headers: {
              'Content-Type': 'multipart/form-data'
            }
        ),
      );
      return Success(message: extractSuccessMessage(response));
    });
  }
  
  @override
  FutureRequest<Success> logout() async{
    return await asyncTryCatch(tryFunc: () async{
      await appPigeon.logOut();
      return Success(message: "Successful logout.");
    });
  }

  @override
  FutureRequest<Success<DescriptionDocs>> loadDescriptions() async{
    return await asyncTryCatch(tryFunc: () async{
      final aboutText = await _descriptionFromRootBundle("assets/docs/ABOUT.md");
      final termsAndConditionText = await _descriptionFromRootBundle("assets/docs/TERMS_AND_CONDITIONS.md");
      final privacyPolicyText = await _descriptionFromRootBundle("assets/docs/PRIVACY_POLICY.md");
      return Success(data: DescriptionDocs(
          aboutApp: aboutText,
          termsAndCondition: termsAndConditionText,
          privacyPolicy: privacyPolicyText,
          acceptableUsePolicy: null,
          cookiesPolicy: null,
          dataOwnershipPolicy: null,
          refundPolicy: null
      ));
    });
  }

  Future<String?> _descriptionFromRootBundle(String path) async{
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      return "Error occured while loading contents!";
    }
  }


  
}
