import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:moo_logue/app/controllers/theme_controller.dart';

import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/modules/authentication/controllers/display_view_controller.dart';

import 'package:moo_logue/app/modules/home/controllers/bottom_bar_controller.dart';
import 'package:moo_logue/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await ScreenUtil.ensureScreenSize();
  await AppStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeController = Get.put(ThemeController());
  final controller = Get.put(BottomBarController());
  final displayController = Get.put(DisplayViewController());

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.black.withOpacity(0.5),
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        builder: (_, child) => Obx(
          () => MaterialApp.router(
            // () => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeController.lightTheme,

            darkTheme: themeController.darkTheme,
            themeMode: themeController.themeMode.value,
            routerConfig: AppPages.routes,
            // home: DemoAudio(),
            builder: (context, child) {
              return Obx(() {
                double scaleFactor;
                switch (displayController.selectedFontIndex.value) {
                  case 0:
                    scaleFactor = 0.9;
                    break;
                  case 2:
                    scaleFactor = 1.1;
                    break;
                  default:
                    scaleFactor = 1.0;
                }
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scaleFactor)),
                  child: child!,
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
