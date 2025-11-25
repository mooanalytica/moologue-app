import 'package:get/get.dart';

import 'package:moo_logue/app/controllers/theme_controller.dart';
import 'package:moo_logue/app/modules/onbording/controllers/onbording_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(OnBordingController());
  }
}
