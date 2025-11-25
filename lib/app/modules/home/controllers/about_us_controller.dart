import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';

class AboutUsController extends GetxController {
  RxList<String> aboutList = [
    AppString.aboutContainerText1,
    AppString.aboutContainerText2,
    AppString.aboutContainerText3,
  ].obs;
}
