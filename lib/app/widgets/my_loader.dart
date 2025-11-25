import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';



class Loader {
  static show(BuildContext context) {
    debugPrint("onKeyboardDismiss");
    FocusScope.of(context).unfocus();
    return context.loaderOverlay.show(
      widgetBuilder: (progress) {
        return const MyLoader();
      },
    );
  }

  static hide(BuildContext context) {
    return context.loaderOverlay.hide();
  }
}

class MyLoader extends StatelessWidget {
  const MyLoader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.all(36.w),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.w)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            showLoader(),
            // Lottie.asset("assets/jsons/new_animation.json", height: 150.h),
          ],
        ),
      ),
    ),
  );
}



