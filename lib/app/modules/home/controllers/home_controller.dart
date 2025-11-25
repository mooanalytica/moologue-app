import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/model/category/response/get_audio_response_model.dart';
import 'package:moo_logue/app/model/category/response/get_category_model.dart';
import 'package:moo_logue/app/model/category/response/get_subcategory_model.dart';
import 'package:moo_logue/app/model/users_response_model.dart';
import 'package:moo_logue/app/utils/common_function.dart';

UserModel? user;

class HomeController extends GetxController {
  final List<DayStreak> weeklyStreak = [
    DayStreak(day: "Mo", status: StreakStatus.future),
    DayStreak(day: "Tu", status: StreakStatus.future),
    DayStreak(day: "We", status: StreakStatus.future),
    DayStreak(day: "Th", status: StreakStatus.future),
    DayStreak(day: "Fr", status: StreakStatus.future),
    DayStreak(day: "Sa", status: StreakStatus.future),
    DayStreak(day: "Su", status: StreakStatus.future),
  ];
  String? type;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchCnt = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _recomputeWeeklyStreak(DateTime.now());
  }

  /// ---------------- LOADING STATE ----------------
  var isLoading = false.obs;
  void setLoading(bool value) => isLoading.value = value;

  /// ---------------- CATEGORY ----------------
  var categories = <CategoryModel>[].obs;
  var lastCategoryDoc = Rx<DocumentSnapshot?>(null);
  var currentCategoryPage = 0.obs;
  var totalCategoryPages = 0.obs;
  final int pageSize = 10;

  TextEditingController subcategoryNameCnt = TextEditingController();
  TextEditingController subcategoryLinkCnt = TextEditingController();
  TextEditingController desCnt = TextEditingController();
  TextEditingController emotionCnt = TextEditingController();
  TextEditingController confidenceCnt = TextEditingController();
  TextEditingController callDurationCnt = TextEditingController();

  String? selectedCategory;
  String? selectedCategoryId;

  Future<void> fetchCategories({int page = 0}) async {
    try {
      setLoading(true);

      Query query = _firestore.collection(adminCategory).orderBy('createdDate', descending: true).limit(pageSize);

      if (page > 0 && lastCategoryDoc.value != null) {
        query = query.startAfterDocument(lastCategoryDoc.value!);
      }

      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        lastCategoryDoc.value = snapshot.docs.last;
      }

      categories.value = snapshot.docs.map((doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      currentCategoryPage.value = page;

      if (page == 0) {
        int totalDocs = (await _firestore.collection(adminCategory).get()).docs.length;
        totalCategoryPages.value = (totalDocs / pageSize).ceil();
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      setLoading(false);
      update();
    }
  }

  /// ---------------- STREAK ----------------
  /// Marks a streak for the given [date] (defaults to today) and updates weekly view
  Future<void> markStreakForToday({DateTime? date}) async {
    final DateTime now = date ?? DateTime.now();
    final String key = _dateKey(now);
    final List<String> streaks = AppStorage.getStringList(AppStorage.streakDates);
    final bool isNewForToday = !streaks.contains(key);
    if (isNewForToday) {
      streaks.add(key);
      await AppStorage.setStringList(AppStorage.streakDates, streaks);
      // Increment user streakCount once per new day
      try {
        final String? uid = AppStorage.getString(AppStorage.userId);
        if (uid != null) {
          await _firestore.collection(usersCollection).doc(uid).set({'streakCount': FieldValue.increment(1)}, SetOptions(merge: true));
        }
      } catch (e) {
        debugPrint('streakCount update failed: $e');
      }
    }
    _recomputeWeeklyStreak(now);
    update();
  }

  void _recomputeWeeklyStreak(DateTime anchor) {
    // Start of week as Monday
    final DateTime monday = anchor.subtract(Duration(days: (anchor.weekday + 6) % 7));
    final List<String> streaks = AppStorage.getStringList(AppStorage.streakDates);
    for (int i = 0; i < 7; i++) {
      final DateTime day = DateTime(monday.year, monday.month, monday.day).add(Duration(days: i));
      final String key = _dateKey(day);
      final bool done = streaks.contains(key);
      final bool isToday = _isSameDate(day, anchor);
      weeklyStreak[i] = DayStreak(
        day: _weekdayLabel(i),
        status: done ? StreakStatus.past : (isToday ? StreakStatus.current : StreakStatus.future),
      );
    }
  }

  String _weekdayLabel(int indexFromMonday) {
    switch (indexFromMonday) {
      case 0:
        return "Mo";
      case 1:
        return "Tu";
      case 2:
        return "We";
      case 3:
        return "Th";
      case 4:
        return "Fr";
      case 5:
        return "Sa";
      default:
        return "Su";
    }
  }

  String _dateKey(DateTime dt) =>
      "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";

  bool _isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> addPlaySoundPts() async {
    String? userId = AppStorage.getString(AppStorage.userId);
    // final user = FirebaseAuth.instance.currentUser;
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance.collection(usersCollection).doc(userId).set({
        'totalPoints': FieldValue.increment(2),
        'endDate': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('award attempt failed: $e');
    }
  }

  Future<void> addViewDetailsPts() async {
    String? userId = AppStorage.getString(AppStorage.userId);
    // final user = FirebaseAuth.instance.currentUser;
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance.collection(usersCollection).doc(userId).set({
        'totalPoints': FieldValue.increment(1),
        'endDate': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('award attempt failed: $e');
    }
  }

  final userStorage = UserStorageService();
  Future<void> searchCategories(String query) async {
    String formattedQuery = capitalizeFirstLetter(query);
    try {
      debugPrint('query==========>>>>>$query');
      setLoading(true);
      if (query.isEmpty) {
        // await fetchCategories(page: 0);
        categories.clear();
        update();
        return;
      }
      update();

      QuerySnapshot snapshot = await _firestore.collection(adminCategory).orderBy(mainCategory).startAt([formattedQuery]).endAt([
        '$formattedQuery\uf8ff',
      ]).get();

      categories.value = snapshot.docs.map((doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      currentCategoryPage.value = 0;
      totalCategoryPages.value = 1;
      update();
    } catch (e) {
      debugPrint("Error searching categories: $e");
      update();
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteCategory(String docId) async {
    try {
      setLoading(true);
      await _firestore.collection(adminCategory).doc(docId).delete();
      categories.removeWhere((cat) => cat.docId == docId);
    } catch (e) {
      debugPrint("Error deleting category: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      String? userId = AppStorage.getString(AppStorage.userId);
      debugPrint('userId==========>>>>>${userId}');
      if (userId == null) {
        print("No user is logged in");
        return null;
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(usersCollection) // replace with your collection name
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final userStorage = UserStorageService();
        final data = snapshot.data() as Map<String, dynamic>;

        DateTime createdAt;
        if (data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        } else if (data['createdAt'] is String) {
          createdAt = DateTime.tryParse(data['createdAt']) ?? DateTime.now();
        } else {
          createdAt = DateTime.now();
        }

        DateTime endDate;
        if (data['endDate'] is Timestamp) {
          endDate = (data['endDate'] as Timestamp).toDate();
        } else if (data['endDate'] is String) {
          endDate = DateTime.tryParse(data['endDate']) ?? DateTime.now();
        } else {
          endDate = DateTime.now();
        }

        final dynamic rawPoints = data['totalPoints'];
        int parsedPoints = 0;
        if (rawPoints is int) {
          parsedPoints = rawPoints;
        } else if (rawPoints is num) {
          parsedPoints = rawPoints.toInt();
        } else if (rawPoints is String) {
          parsedPoints = int.tryParse(rawPoints) ?? 0;
        }

        final dynamic streakPoints = data['streakCount'];
        int parsedStreakPoints = 0;
        if (streakPoints is int) {
          parsedStreakPoints = streakPoints;
        } else if (streakPoints is num) {
          parsedStreakPoints = streakPoints.toInt();
        } else if (streakPoints is String) {
          parsedStreakPoints = int.tryParse(streakPoints) ?? 0;
        }
        await userStorage.saveUser(
          UserModel(
            createdAt: createdAt,
            email: data['email'] ?? "",
            firstName: data['firstName'] ?? "",
            lastName: data['lastName'] ?? "",
            photo: data['photo'] ?? "",
            totalPoints: parsedPoints,
            endDate: endDate,
            streakCount: parsedStreakPoints,
          ),
        );
        user = userStorage.getUser();
        debugPrint('user==========>>>>>${user?.photo}');
        return data;
      } else {
        print("User document not found");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    } finally {
      update();
    }
  }

  /// ---------------- SUBCATEGORY ----------------
  var subcategories = <SubCategoryModel>[].obs;
  var lastSubDoc = Rx<DocumentSnapshot?>(null);
  var currentSubPage = 0.obs;
  var totalSubPages = 0.obs;
  final int pageSubSize = 10;
  var subPageCursors = <DocumentSnapshot>[].obs;

  Future<void> fetchSubCategories({int page = 0}) async {
    try {
      setLoading(true);

      Query query = _firestore.collection(adminSubcategory).orderBy('createdDate', descending: false);

      if (page > 0 && page <= subPageCursors.length) {
        query = query.startAfterDocument(subPageCursors[page - 1]);
      }

      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        if (page >= subPageCursors.length) {
          subPageCursors.add(snapshot.docs.last);
        } else {
          subPageCursors[page] = snapshot.docs.last;
        }
      }

      subcategories.value = snapshot.docs.map((doc) => SubCategoryModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
      update();
      currentSubPage.value = page;

      if (page == 0) {
        int totalDocs = (await _firestore.collection(adminSubcategory).get()).docs.length;
        totalSubPages.value = (totalDocs / pageSubSize).ceil();
      }
    } catch (e) {
      debugPrint("Error fetching subcategories: $e");
    } finally {
      setLoading(false);
      update();
    }
  }

  Future<void> searchSubCategories(String query) async {
    String formattedQuery = capitalizeFirstLetter(query);
    try {
      debugPrint('query==========>>>>>$query');
      setLoading(true);
      if (query.isEmpty) {
        // await fetchCategories(page: 0);
        subcategories.clear();
        update();
        return;
      }
      update();

      QuerySnapshot snapshot = await _firestore.collection(adminSubcategory).orderBy(subCategory).startAt([formattedQuery]).endAt([
        '$formattedQuery\uf8ff',
      ]).get();

      subcategories.value = snapshot.docs.map((doc) => SubCategoryModel.fromJson(doc.data() as Map<String, dynamic>)).toList();

      currentSubPage.value = 0;
      totalSubPages.value = 1;
      update();
    } catch (e) {
      debugPrint("Error searching categories: $e");
      update();
    } finally {
      setLoading(false);
    }
  }

  Future<void> addFieldsToCategoryDocs() async {
    try {
      final collectionRef = _firestore.collection(adminCategoryAudio);
      QuerySnapshot snapshot = await collectionRef.get();

      for (var doc in snapshot.docs) {
        await collectionRef.doc(doc.id).update({"emotion": "", "callDuration": 0, "description": "", "confident": 0});
      }
    } catch (e) {
      debugPrint("Error adding fields: $e");
    }
  }

  /// ---------------- FETCH AUDIO ----------------
  var audioData = <MaternalCall>[].obs;
  var lastAudioSubDoc = Rx<DocumentSnapshot?>(null);
  var currentAudioSubPage = 0.obs;
  var totalAudioSubPages = 0.obs;
  final int pageAudioSubSize = 10;
  var subAudioPageCursors = <DocumentSnapshot>[].obs;

  var audiosData = <AudioDataResponseModel>[].obs;

  void loadAudioDataFromMaternalCalls() {
    audiosData.clear();
    for (final call in audioData) {
      if (call.audioData != null) {
        audiosData.addAll(call.audioData!);
      }
    }
  }

  Future<void> fetchMaternalCallsBySubCategory({required String categoryId, int page = 0}) async {
    try {
      setLoading(true);
      update();

      Query query = _firestore
          .collection(adminCategoryAudio) // collection: adminCategoryAudio
          .where(subCategoryId, isEqualTo: categoryId) // filter by subCategory
          .orderBy('createdDate', descending: true)
          .limit(pageAudioSubSize);

      // Pagination
      if (page > 0 && page <= subAudioPageCursors.length) {
        query = query.startAfterDocument(subAudioPageCursors[page - 1]);
      }

      QuerySnapshot snapshot = await query.get();

      // Save cursor
      if (snapshot.docs.isNotEmpty) {
        if (page >= subAudioPageCursors.length) {
          subAudioPageCursors.add(snapshot.docs.last);
        } else {
          subAudioPageCursors[page] = snapshot.docs.last;
        }
      }

      // 🔹 Convert docs → MaternalCall model
      final newData = snapshot.docs.map((doc) {
        return MaternalCall.fromDoc(doc);
      }).toList();

      // 🔹 Append or replace depending on page
      if (page == 0) {
        audioData.value = newData;
      } else {
        audioData.addAll(newData);
      }

      currentAudioSubPage.value = page;

      // 🔹 Count total docs only once
      if (page == 0) {
        int totalDocs = (await _firestore.collection(adminCategoryAudio).where(subCategoryId, isEqualTo: categoryId).get()).docs.length;
        totalAudioSubPages.value = (totalDocs / pageSubSize).ceil();
      }
      loadAudioDataFromMaternalCalls();
      setLoading(false);
      update();
    } catch (e) {
      debugPrint("Error fetching MaternalCalls: $e");
      update();
    } finally {
      setLoading(false);
      update();
    }
  }

  Future<void> searchSubAudioCategories(String query) async {
    String formattedQuery = capitalizeFirstLetter(query);
    try {
      debugPrint('query==========>>>>>$query');
      setLoading(true);
      if (query.isEmpty) {
        // await fetchCategories(page: 0);
        audiosData.clear();
        update();
        return;
      }
      update();

      QuerySnapshot snapshot = await _firestore.collection(adminCategoryAudio).orderBy(subCategory).startAt([formattedQuery]).endAt([
        '$formattedQuery\uf8ff',
      ]).get();
      final newData = snapshot.docs.map((doc) {
        return MaternalCall.fromDoc(doc);
      }).toList();
      audioData.value = newData;
      loadAudioDataFromMaternalCalls();
      currentSubPage.value = 0;
      totalSubPages.value = 1;
      update();
    } catch (e) {
      debugPrint("Error searching categories: $e");
      update();
    } finally {
      setLoading(false);
    }
  }
}

enum StreakStatus { past, current, future }

class DayStreak {
  final String day;
  final StreakStatus status;

  DayStreak({required this.day, required this.status});
}
