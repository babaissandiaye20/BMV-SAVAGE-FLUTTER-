import 'package:get/get.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/create_appointment/bindings/create_appointment_binding.dart';
import '../modules/create_appointment/views/create_appointment_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/otp/bindings/otp_binding.dart';
import '../modules/login/otp/views/otp_view.dart';
import '../modules/login/views/login_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/complete_profile/bindings/register_complete_profile_binding.dart';
import '../modules/register/complete_profile/views/register_complete_profile_view.dart';
import '../modules/register/views/register_view.dart';
import '../modules/upload_documents/bindings/upload_documents_binding.dart';
import '../modules/upload_documents/views/upload_documents_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
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
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),

    // ✅ ROUTE COMPLÉMENTAIRE CORRECTEMENT PLACÉE AU NIVEAU RACINE
    GetPage(
      name: _Paths.REGISTER_COMPLETE_PROFILE,
      page: () => const CompleteProfileView(),
      binding: RegisterCompleteProfileBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_APPOINTMENT,
      page: () => const CreateAppointmentView(),
      binding: CreateAppointmentBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
  ];
}
