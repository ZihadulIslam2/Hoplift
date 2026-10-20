import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/description_docs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/change_password_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/update_profile_avatar_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/update_profile_model.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/user_profile.dart';

 abstract base class ProfileInterface extends BaseRepository{
  
  FutureRequest<Success> changePassword(ChangePassowrdParam params);

  FutureRequest<Success<UserProfile>> getUserProfilebyId(String id);
  
  FutureRequest<Success> updateProfile(UpdateProfileParam params);

  FutureRequest<Success> uploadProfileAvatar(UploadProfileAvatarParam params);

  FutureRequest<Success> logout();

  FutureRequest<Success<DescriptionDocs>> loadDescriptions();
}