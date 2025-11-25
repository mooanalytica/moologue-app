import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moo_logue/app/core/constants/app_assets.dart';
import 'package:moo_logue/app/core/constants/app_const.dart';
import 'package:moo_logue/app/core/constants/app_strings.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/model/category/response/get_audio_response_model.dart';
import 'package:moo_logue/app/model/category/response/get_subcategory_model.dart';

class EmotionalCallsController extends GetxController {
  RxList<Map<String, dynamic>> emotionalContainerList = <Map<String, dynamic>>[
    {
      'emotionalContainerImage': AppAssets.audio1,
      'emotionalContainerName': AppString.fenceInteractionCall,
    },
    {
      'emotionalContainerImage': AppAssets.audio2,
      'emotionalContainerName': AppString.impatienceCall,
    },
    {
      'emotionalContainerImage': AppAssets.audio3,
      'emotionalContainerName': AppString.feedingFrustration,
    },
    {
      'emotionalContainerImage': AppAssets.audio4,
      'emotionalContainerName': AppString.painBellow,
    },
  ].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ---------------- LOADING STATE ----------------
  var isLoading = false.obs;
  void setLoading(bool value) => isLoading.value = value;

  /// ---------------- SUBCATEGORY ----------------
  var audioData = <MaternalCall>[].obs;
  var lastSubDoc = Rx<DocumentSnapshot?>(null);
  var currentSubPage = 0.obs;
  var totalSubPages = 0.obs;
  final int pageSubSize = 10;
  var subPageCursors = <DocumentSnapshot>[].obs;


  var audiosData = <AudioDataResponseModel>[].obs;

  void loadAudioDataFromMaternalCalls() {
    audiosData.clear();
    for (final call in audioData) {
      if (call.audioData != null) {
        audiosData.addAll(call.audioData!);
      }
    }
  }
  Future<void> addPlaySoundPts() async {

    String? userId = AppStorage.getString(AppStorage.userId);
    // final user = FirebaseAuth.instance.currentUser;
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(userId)
          .set({
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
      await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(userId)
          .set({
        'totalPoints': FieldValue.increment(1),
        'endDate': Timestamp.now(),
      }, SetOptions(merge: true));

    } catch (e) {
      debugPrint('award attempt failed: $e');
    }
  }

  Future<void> fetchMaternalCallsBySubCategory({
    required String categoryId,
    int page = 0,
  }) async {
    try {
      setLoading(true);
      update();

      Query query = _firestore
          .collection(adminCategoryAudio) // collection: adminCategoryAudio
          .where(subCategoryId, isEqualTo: categoryId) // filter by subCategory
          .orderBy('createdDate', descending: true)
          .limit(pageSubSize);

      // Pagination
      if (page > 0 && page <= subPageCursors.length) {
        query = query.startAfterDocument(subPageCursors[page - 1]);
      }

      QuerySnapshot snapshot = await query.get();

      // Save cursor
      if (snapshot.docs.isNotEmpty) {
        if (page >= subPageCursors.length) {
          subPageCursors.add(snapshot.docs.last);
        } else {
          subPageCursors[page] = snapshot.docs.last;
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

      currentSubPage.value = page;

      // 🔹 Count total docs only once
      if (page == 0) {
        int totalDocs = (await _firestore
            .collection(adminCategoryAudio)
            .where(subCategoryId, isEqualTo: categoryId)
            .get())
            .docs
            .length;
        totalSubPages.value = (totalDocs / pageSubSize).ceil();
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

  /// ---------------- MAIN CATEGORY WISE SUBCATEGORY ----------------
  var subIdCategories = <SubCategoryModel>[].obs;
  var lastIdSubDoc = Rx<DocumentSnapshot?>(null);
  var currentIdSubPage = 0.obs;
  var totalIdSubPages = 0.obs;
  final int pageIdSubSize = 10;
  var subIdPageCursors = <DocumentSnapshot>[].obs;



  Future<void> fetchIdSubCategories({int page = 0,String? id}) async {
    try {
      setLoading(true);
      update();
      Query query = _firestore
          .collection(adminSubcategory).where(mainCategoryId,isEqualTo:id )
          .orderBy('createdDate', descending: true);
      update();
      if (page > 0 && page <= subIdPageCursors.length) {
        query = query.startAfterDocument(subIdPageCursors[page - 1]);
      }

      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        if (page >= subIdPageCursors.length) {
          subIdPageCursors.add(snapshot.docs.last);
        } else {
          subIdPageCursors[page] = snapshot.docs.last;
        }
      }

      subIdCategories.value = snapshot.docs
          .map((doc) => SubCategoryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      currentIdSubPage.value = page;

      if (page == 0) {
        int totalDocs =
            (await _firestore.collection(adminSubcategory).get()).docs.length;
        totalIdSubPages.value = (totalDocs / pageIdSubSize).ceil();
      }

    } catch (e) {

      debugPrint("Error fetching subcategories: $e");
    } finally {
      setLoading(false);
      update();
    }

  }


}
