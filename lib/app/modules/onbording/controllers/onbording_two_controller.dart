import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';

class OnbordingTwoController extends GetxController {
  RxList<Map<String, dynamic>> mooLogue = <Map<String, dynamic>>[
    {
      'Image': AppAssets.moologueOne,
      'Title': AppString.onBordingTwoTitle1,
      'SubTitle': AppString.onBordingTwoSubTitle1,
    },
    {
      'Image': AppAssets.moologueTwo,
      'Title': AppString.onBordingTwoTitle2,
      'SubTitle': AppString.onBordingTwoSubTitle2,
    },
    {
      'Image': AppAssets.moologueThree,
      'Title': AppString.onBordingTwoTitle3,
      'SubTitle': AppString.onBordingTwoSubTitle3,
    },
  ].obs;
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  Future<void> scrollTap() async {
    final nextPage = currentPage.value + 1;
    if (nextPage < mooLogue.length) {
      currentPage.value = nextPage;
      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      print('nextPage======>${nextPage}');
    } else if (nextPage == 3) {
      await ctx!.push(Routes.loginView);
    } else {
      print("Reached the last page");
    }
  }
}
