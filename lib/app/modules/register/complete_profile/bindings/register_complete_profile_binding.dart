import 'package:get/get.dart';

import '../controllers/register_complete_profile_controller.dart';

class RegisterCompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompleteProfileController>(
      () => CompleteProfileController(),
    );
  }
}
