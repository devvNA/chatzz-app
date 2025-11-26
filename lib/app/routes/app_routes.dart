part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const HOME = _Paths.HOME;
  static const CHAT = _Paths.CHAT;
  static const NEW_CHAT = _Paths.NEW_CHAT;
  static const PROFILE = _Paths.PROFILE;
  static const SETTINGS = _Paths.SETTINGS;
  static const BASE = _Paths.BASE;
  static const CONTACTS = _Paths.CONTACTS;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const CHAT = '/chat';
  static const NEW_CHAT = '/new-chat';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const BASE = '/base';
  static const CONTACTS = '/contacts';
}
