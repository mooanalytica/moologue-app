import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/model/users_response_model.dart';

class LeaderBoardController extends GetxController {
  var selectedIndex = 0.obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
    _applyFilter();
  }

  RxList<Map<String, dynamic>> weekList = <Map<String, dynamic>>[
    {
      "Icon": AppAssets.weekoneIcon,
      "Image": AppAssets.weekOneImage,
      "Title": AppString.weekOneText,
      "SubTitle": AppString.weekOneDisc,
      "Points": AppString.weekOnePoints,
    },
    {
      "Icon": AppAssets.weektwoIcon,
      "Image": AppAssets.weekTwoImage,
      "Title": AppString.weekTwoText,
      "SubTitle": AppString.weekTwoDisc,
      "Points": AppString.weekTwoPoints,
    },
    {
      "Icon": AppAssets.weekthreeIcon,
      "Image": AppAssets.weekThreeImage,
      "Title": AppString.weekThreeText,
      "SubTitle": AppString.weekThreeDisc,
      "Points": AppString.weekThreePoints,
    },
    {
      "Digit": AppString.weekDigitFour,
      "Image": AppAssets.weekFourImage,
      "Title": AppString.weekFourText,
      "SubTitle": AppString.weekFourDisc,
      "Points": AppString.weekFourPoints,
    },
    {
      "Digit": AppString.weekDigitFive,
      "Image": AppAssets.weekFiveImage,
      "Title": AppString.weekFiveText,
      "SubTitle": AppString.weekFiveDisc,
      "Points": AppString.weekFivePoints,
    },
    {
      "Digit": AppString.weekDigitSix,
      "Image": AppAssets.weekSixImage,
      "Title": AppString.weekSixText,
      "SubTitle": AppString.weekSixDisc,
      "Points": AppString.weekSixPoints,
    },
    {
      "Digit": AppString.weekDigitSeven,
      "Image": AppAssets.weekSevenImage,
      "Title": AppString.weekSevenText,
      "SubTitle": AppString.weekSevenDisc,
      "Points": AppString.weekSevenPoints,
    },
    {
      "Digit": AppString.weekDigitEight,
      "Image": AppAssets.weekOneImage,
      "Title": AppString.weekEightText,
      "SubTitle": AppString.weekEightDisc,
      "Points": AppString.weekEightPoints,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final query = await _firestore
          .collection(usersCollection)
          .orderBy('totalPoints', descending: true)
          .get();

      final List<UserModel> users = query.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      allUsers.assignAll(users);
      _applyFilter();
    } catch (e) {
      debugPrint('Error fetching users for leaderboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilter() {
    if (allUsers.isEmpty) {
      filteredUsers.clear();
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    final DateTime weekAgo = now.subtract(Duration(days: 7));
    final DateTime monthAgo = now.subtract(Duration(days: 30));

    List<UserModel> result;

    switch (selectedIndex.value) {
      case 0: // Today
        result = allUsers.where((u) {
          final DateTime? end = u.endDate;
          if (end == null) return false;
          return end.isAfter(todayStart);
        }).toList();
        break;
      case 1: // Week
        result = allUsers.where((u) {
          final DateTime? end = u.endDate;
          if (end == null) return false;
          return end.isAfter(weekAgo);
        }).toList();
        break;
      case 2: // Month
        result = allUsers.where((u) {
          final DateTime? end = u.endDate;
          if (end == null) return false;
          return end.isAfter(monthAgo);
        }).toList();
        break;
      default: // All-time
        result = List<UserModel>.from(allUsers);
    }

    // Sort by points desc, secondary by endDate desc
    result.sort((a, b) {
      final int pointsA = a.totalPoints ?? 0;
      final int pointsB = b.totalPoints ?? 0;
      if (pointsA != pointsB) return pointsB.compareTo(pointsA);
      final int dateCmp = (b.endDate ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.endDate ?? DateTime.fromMillisecondsSinceEpoch(0));
      return dateCmp;
    });

    filteredUsers.assignAll(result);
  }
}
