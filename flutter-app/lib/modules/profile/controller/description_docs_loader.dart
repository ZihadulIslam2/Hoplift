import 'package:get/state_manager.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/interface/profile_interface.dart';

import '../../../../core/utils/helpers/handle_fold.dart';
import '../../../app/init_dependency.dart';
import '../model/description_docs.dart';

class DescriptionDocsLoader extends GetxController{

  
  DescriptionDocs? _descriptionDocs;
  DescriptionDocs? get descriptionDocs => _descriptionDocs;

  init() async{
    await loadLegals();
  }
  
  Future<void> loadLegals() async{
    if(descriptionDocs != null) return;
    await serviceLocator<ProfileInterface>().loadDescriptions().then((lr) {
      handleFold(
        either: lr,
        onSuccess: (data) {
          _descriptionDocs = data;
          update();
        }
      );
    });
  }
}