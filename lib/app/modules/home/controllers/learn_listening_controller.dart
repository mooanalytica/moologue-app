import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';

class LearnListeningController extends GetxController {
  RxList<Map<String, dynamic>> learnListening = <Map<String, dynamic>>[
    {
      'LearnName': AppString.emotionalCalls,
      'LearnDisc': AppString.emotionalCallsDisc,
      'LearnImage': AppAssets.category1,
    },
    {
      'LearnName': AppString.feelingsSounds,
      'LearnDisc': AppString.feelingsSoundsDisc,
      'LearnImage': AppAssets.category2,
    },
    {
      'LearnName': AppString.feelingsSounds,
      'LearnDisc': AppString.feelingsSoundsDisc,
      'LearnImage': AppAssets.category3,
    },
    {
      'LearnName': AppString.feelingsSounds,
      'LearnDisc': AppString.feelingsSoundsDisc,
      'LearnImage': AppAssets.category4,
    },
    {
      'LearnName': AppString.feelingsSounds,
      'LearnDisc': AppString.feelingsSoundsDisc,
      'LearnImage': AppAssets.category5,
    },
  ].obs;
  RxList<Map<String, dynamic>> learnListeningTwo = <Map<String, dynamic>>[
    {'LevelDisc': AppString.levelOneDisc},
    // {'LevelNumber': AppString.levelTwo, 'LevelDisc': AppString.levelTwoDisc},
  ].obs;
}
