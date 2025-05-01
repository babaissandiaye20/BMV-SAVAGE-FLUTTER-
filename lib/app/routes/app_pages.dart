import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/otp/bindings/otp_binding.dart';
import '../modules/login/otp/views/otp_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/upload_documents/bindings/upload_documents_binding.dart';
import '../modules/upload_documents/views/upload_documents_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
      children: [
        GetPage(
          name: _Paths.OTP,
          page: () => const OtpView(),
          binding: OtpBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.UPLOAD_DOCUMENTS,
      page: () => const UploadDocumentsView(),
      binding: UploadDocumentsBinding(),
    ),
  ];
}
