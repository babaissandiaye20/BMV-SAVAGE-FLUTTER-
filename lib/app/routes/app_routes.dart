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
}
