import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // Splash route - will be implemented in task 4.4
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    // Auth routes - will be implemented in task 4
    // GetPage(
    //   name: _Paths.LOGIN,
    //   page: () => const LoginView(),
    //   binding: LoginBinding(),
    // ),
    // GetPage(
    //   name: _Paths.REGISTER,
    //   page: () => const RegisterView(),
    //   binding: RegisterBinding(),
    // ),

    // Home route
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.SPLASH,
          page: () => const SplashView(),
          binding: SplashBinding(),
        ),
      ],
    ),

    // Chat route - will be implemented in task 7
    // GetPage(
    //   name: _Paths.CHAT,
    //   page: () => const ChatView(),
    //   binding: ChatBinding(),
    // ),

    // Profile route - future implementation
    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => const ProfileView(),
    //   binding: ProfileBinding(),
    // ),
  ];
}
