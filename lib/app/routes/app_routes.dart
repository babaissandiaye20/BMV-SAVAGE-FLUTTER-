part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const LOGIN_OTP = '/login/otp';
  static const UPLOAD_DOCUMENTS = _Paths.UPLOAD_DOCUMENTS;
  static const CHAT = _Paths.CHAT;
  static const PROFILE = _Paths.PROFILE;
  static const REGISTER = _Paths.REGISTER;
  static const REGISTER_COMPLETE_PROFILE = _Paths.REGISTER_COMPLETE_PROFILE;
  static const CREATE_APPOINTMENT = _Paths.CREATE_APPOINTMENT;
  static const PAYMENT = _Paths.PAYMENT;
  static const RECEIPT_INFO = _Paths.RECEIPT_INFO; // 👈 Ajouté ici
  static const LANDING = _Paths.LANDING;
  static const CONFIRM_PAYMENT = _Paths.CONFIRM_PAYMENT;

}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN = '/login';
  static const OTP = '/otp';
  static const UPLOAD_DOCUMENTS = '/upload-documents';
  static const CHAT = '/chat';
  static const PROFILE = '/profile';
  static const REGISTER = '/register';
  static const REGISTER_COMPLETE_PROFILE = '/complete-profile';
  static const CREATE_APPOINTMENT = '/create-appointment';
  static const PAYMENT = '/payment';
  static const RECEIPT_INFO = '/receipt-info'; // 👈 Ajouté ici
  static const LANDING = '/landing';
  static const CONFIRM_PAYMENT = '/confirm-payment';

}
