import 'package:chatzz/app/core/theme/app_theme.dart';
import 'package:chatzz/app/routes/app_pages.dart';
import 'package:chatzz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    GetStorage.init(), // Required: LocalStorage digunakan di splash screen
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ), // Cri
  ]);
  await AppPages.initServices();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus != null && !currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: GetMaterialApp(
        // initialBinding: AppBinding(),
        popGesture: true,
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
