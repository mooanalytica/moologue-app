import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/modules/home/views/about_us_view.dart';
import 'package:moo_logue/app/modules/home/views/home_view.dart';
import 'package:moo_logue/app/modules/home/views/leader_board_view.dart';
import 'package:moo_logue/app/modules/home/views/learn_listening_view.dart';
import 'package:moo_logue/app/modules/home/widgets/glass_effect_view.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = 0.obs;

  Future<void> onItemTapped(int index) async {
    // Animate to new page
    final oldIndex = currentIndex.value;
    currentIndex.value = index;
    if (currentIndex.value != oldIndex) {
      if (index == 0) {
        await AppStorage.setString(AppStorage.typeState, TypeState.mainCategory.toString());
        ctx!.go(Routes.homeView);
      } else if (index == 1) {
        await AppStorage.setString(AppStorage.typeState, TypeState.mainCategory.toString());
        ctx!.go(Routes.learnListeningView);
      } else if (index == 2) {
        await AppStorage.setString(AppStorage.typeState, TypeState.mainCategory.toString());
        ctx!.go(Routes.learnBoardView);
      } else if (index == 3) {
        await AppStorage.setString(AppStorage.typeState, TypeState.mainCategory.toString());
        ctx!.go(Routes.aboutUsView);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
