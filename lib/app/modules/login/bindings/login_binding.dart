import 'package:get/get.dart';
import 'package:salvage_app/app/modules/login/controllers/login_controller.dart'
    show LoginController;

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
