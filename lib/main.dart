import 'package:chatzz/app/core/theme/app_theme.dart';
import 'package:chatzz/app/core/theme/theme_controller.dart';
import 'package:chatzz/app/routes/app_pages.dart';
import 'package:chatzz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    GetStorage.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);

  // Initialize ThemeController before running app
  Get.put(ThemeController(), permanent: true);

  await AppPages.initServices();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus != null && !currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Obx(
        () => GetMaterialApp(
          key: ValueKey(themeController.isDarkMode),
          popGesture: true,
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          darkTheme: myDarkTheme,
          themeMode: themeController.themeMode,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        ),
      ),
    );
  }
}
