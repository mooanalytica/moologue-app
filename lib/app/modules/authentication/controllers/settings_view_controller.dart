import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/api/api_constant.dart';
import 'package:moo_logue/app/api/api_service.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/model/users_response_model.dart';

class SettingsViewController extends GetxController {
  RxList<Map<String, dynamic>> settingsList = <Map<String, dynamic>>[
    {'SettingsIcon': AppAssets.accountInfo_icon, 'SettingsName': AppString.accountInfo},
    {'SettingsIcon': AppAssets.display_icon, 'SettingsName': AppString.display},
    {'SettingsIcon': AppAssets.helpCenter_icon, 'SettingsName': AppString.helpCenter},
    {'SettingsIcon': AppAssets.delete, 'SettingsName': AppString.delete},
    {'SettingsIcon': AppAssets.logout_icon, 'SettingsName': AppString.logout},
  ].obs;

  Future<void> deleteUserAccount(BuildContext context) async {
    try {
      String? userId = AppStorage.getString(AppStorage.userId);

      User? user = FirebaseAuth.instance.currentUser;
      final userStorage = UserStorageService();
      UserModel? userModel = userStorage.getUser();

      print("User data deleted from Firestore");
      var body = {"filename": userModel?.photo};

      var response = await APIService().postAPI(url: AppUrls.deleteFiles, body: body, isMultipart: false, context: context);

      if (response == null || response.data == null) {
        throw Exception("Image upload failed, response is null");
      }
      await FirebaseFirestore.instance.collection(usersCollection).doc(userId).delete();
      if (userId != null && userId != "password") {
        await user?.delete();
        print("User deleted from Firebase Authentication");
      } else {
        print("Normal login → only Firestore data deleted");
      }

      // Sign out user
      await FirebaseAuth.instance.signOut();
      AppStorage.logout(); // return true
    } catch (e) {
      print("Error deleting account: $e");
    }
  }
}
