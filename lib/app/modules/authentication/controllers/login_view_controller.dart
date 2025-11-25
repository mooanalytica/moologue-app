import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moo_logue/app/api/api_constant.dart';
import 'package:moo_logue/app/api/api_service.dart';
import 'package:moo_logue/app/core/constants/app_colors.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/routes/app_routes.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginViewController extends GetxController {
  TextEditingController loginEmailCnt = TextEditingController();
  TextEditingController loginPasswordCnt = TextEditingController();
  final storage = GetStorage();
  RxBool isButtonEnabled = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isShowPasswordOptionShow = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void checkForButtonEnabled() {
    bool oldValue = isButtonEnabled.value;
    if (loginEmailCnt.text.isNotEmpty && loginPasswordCnt.text.isNotEmpty) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }

    if (oldValue != isButtonEnabled.value) {
      update();
    }
  }

  void checkForPasswordVisibility() {
    bool oldValue = isShowPasswordOptionShow.value;
    log('passwordController.text==============>>>${loginPasswordCnt.text}');
    if (loginPasswordCnt.text.isNotEmpty) {
      isShowPasswordOptionShow.value = true;
    } else {
      isShowPasswordOptionShow.value = false;
    }

    if (oldValue != isShowPasswordOptionShow.value) {
      update();
    }
  }

  void clearController() {
    loginEmailCnt.clear();
    loginPasswordCnt.clear();

    update();
  }

  // Future<void> signInWithEmail(BuildContext context) async {
  //   showLoaderDialog(context);
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: loginEmailCnt.text,
  //       password: loginPasswordCnt.text,
  //     );
  //
  //
  //     User? user = userCredential.user;
  //
  //     if (user != null) {
  //
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('users') // your collection name
  //           .doc(user.uid)
  //           .get();
  //
  //       if (userDoc.exists) {
  //         var userData = userDoc.data() as Map<String, dynamic>;
  //
  //         bool isVerity = userData['is_user_verify'] ?? '';
  //       if(isVerity){
  //         ctx!.go(Routes.homeView);
  //
  //       }else{
  //         await ctx!.push(
  //           Routes.resetVerificationView,
  //           extra: {'email': loginEmailCnt.text},
  //         );
  //       }
  //
  //
  //
  //         AppStorage.setLogin(true);
  //
  //
  //         showSnackBar(
  //           context,
  //           // 'Welcome $name!',
  //           'Logged in successfully!',
  //           backgroundColor: AppColors.primary,
  //         );
  //       } else {
  //         showSnackBar(context, 'User data not found in database');
  //       }
  //     }
  //
  //     clearController();
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage;
  //     switch (e.code) {
  //       case 'invalid-email':
  //         errorMessage = 'Invalid email format.';
  //         break;
  //       case 'user-disabled':
  //         errorMessage = 'This account has been disabled.';
  //         break;
  //       case 'user-not-found':
  //         errorMessage = 'No account found for that email.';
  //         break;
  //       case 'wrong-password':
  //         errorMessage = 'Incorrect password.';
  //         break;
  //       default:
  //         errorMessage = 'Login failed. Please try again.';
  //     }
  //     showSnackBar(context, errorMessage);
  //   } catch (e) {
  //     showSnackBar(context, 'Something went wrong. Please try again.');
  //   } finally {
  //     hideLoaderDialog(context);
  //   }
  // }
  Future<void> signInWithEmail(BuildContext context) async {
    showLoaderDialog(context);
    try {
      final String email = loginEmailCnt.text.trim();
      final String password = loginPasswordCnt.text.trim();

      final QuerySnapshot userQuery = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (userQuery.docs.isEmpty) {
        hideLoaderDialog(context);
        showSnackBar(context, 'No account found for that email.', backgroundColor: Colors.red);
        return;
      }

      final userDoc = userQuery.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['password'] != password) {
        hideLoaderDialog(context);
        showSnackBar(context, 'Incorrect password.', backgroundColor: Colors.red);
        return;
      }

      bool isVerified = userData['is_user_verify'] ?? false;
      if (isVerified) {
        showSnackBar(context, 'Logged in successfully!', backgroundColor: AppColors.primary);
        ctx!.go(Routes.homeView);
      } else {
        showSnackBar(context, 'Please verify your email', backgroundColor: AppColors.primary);
        await sendOtp(context, email);
      }

      await AppStorage.setLogin(true);
      await AppStorage.setString(AppStorage.userId, userDoc.id);

      clearController();
    } catch (e) {
      log("Login error: $e");
      showSnackBar(context, 'Something went wrong. Please try again.', backgroundColor: Colors.red);
    }
  }

  Future<void> sendOtp(BuildContext context, String email) async {
    try {
      var response = await APIService().postAPI(url: AppUrls.sendOtp, body: {"email": email}, isMultipart: false, context: context);
      print('response==========>>>>>${response!.statusCode}');
      if (response.data['success'] == false) {
        showSnackBar(context, response.data['message'], backgroundColor: Colors.red);
        update();
      } else {
        await ctx!.push(Routes.resetVerificationView, extra: {'email': email, "isCreate": true});

        update();
      }
      hideLoaderDialog(context);
    } catch (e) {
      hideLoaderDialog(context);
      update();
    }
  }

  ///=========================GOOGlE LOGIN=================================

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showLoaderDialog(context);

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        forceCodeForRefreshToken: true,
        signInOption: SignInOption.standard,
      );

      // Ensure previous sessions are cleared
      await googleSignIn.signOut();

      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        hideLoaderDialog(context);
        return;
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      hideLoaderDialog(context);

      if (firebaseUser != null) {
        String fullName = firebaseUser.displayName ?? '';
        List<String> nameParts = fullName.trim().split(' ');
        String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();

        if (!userDoc.exists) {
          // 🔹 New user → create document
          await _firestore.collection('users').doc(firebaseUser.uid).set({
            'firstName': firstName,
            'lastName': lastName,
            'email': firebaseUser.email,
            'photo': firebaseUser.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'user_id': firebaseUser.uid,
            'type': "Google",
            'isUserBlock': false,
          });
        } else {
          await _firestore.collection('users').doc(firebaseUser.uid).update({'lastLogin': FieldValue.serverTimestamp()});
        }

        await AppStorage.setString(AppStorage.userId, firebaseUser.uid);
        AppStorage.setLogin(true);

        showSnackBar(context, 'Google login successful!', backgroundColor: AppColors.primary);
        ctx!.go(Routes.homeView);
      }
    } catch (e) {
      hideLoaderDialog(context);
      log("Google Sign-In failed: $e");
    }
  }

  ///=========================FACEBOOK LOGIN=================================

  Future<void> signWithFacebook(BuildContext context) async {
    showLoaderDialog(context);
    try {
      await FacebookAuth.instance.logOut();

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
        loginBehavior: LoginBehavior.webOnly,
      );

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        if (accessToken != null) {
          log('accessToken=================>>>>>${accessToken}');

          final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);

          try {
            final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
            final User? firebaseUser = userCredential.user;

            if (firebaseUser != null) {
              String email = firebaseUser.email ?? 'no-email-provided@facebook.com';
              String firstName = firebaseUser.displayName?.split(' ').first ?? 'First';
              String lastName = firebaseUser.displayName?.split(' ').last ?? 'Last';
              await _firestore.collection('users').doc(firebaseUser.uid).set({
                'firstName': firstName,
                'lastName': lastName,
                'email': email,
                'photo': firebaseUser.photoURL,
                'isUserBlock': false,
                'createdAt': FieldValue.serverTimestamp(),
              });
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'account-exists-with-different-credential') {
              final String email = e.email ?? 'unknown';
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facebook login failed: ${e.message}')));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get access token.')));
        }
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login cancelled by the user.')));
      } else if (result.status == LoginStatus.failed) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Facebook login failed: ${result.message}')));
      }
    } catch (e) {
      log('Facebook login failed:=================>>>>>$e');
    } finally {
      hideLoaderDialog(context);
    }
  }

  ///=========================APPLE LOGIN=================================

  String generateNonce([int length = 32]) {
    final random = Random.secure();
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  // SHA256 hash helper
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      showLoaderDialog(context);

      String sha256ofString(String input) {
        final bytes = utf8.encode(input);
        final digest = sha256.convert(bytes);
        return digest.toString();
      }

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
        nonce: nonce,
      );

      if (appleCredential.identityToken == null) {
        hideLoaderDialog(context);
        showSnackBar(context, 'Apple Sign-In failed: No identity token received', backgroundColor: Colors.red);
        return;
      }

      if (appleCredential.authorizationCode == null) {
        hideLoaderDialog(context);
        showSnackBar(context, 'Apple Sign-In failed: No authorization code received', backgroundColor: Colors.red);
        return;
      }

      final oauthCredential = OAuthProvider(
        'apple.com',
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce, accessToken: appleCredential.authorizationCode);

      final authResult = await _auth.signInWithCredential(oauthCredential);
      final firebaseUser = authResult.user;

      if (firebaseUser != null) {
        String firstName = appleCredential.givenName ?? '';
        String lastName = appleCredential.familyName ?? '';

        if (firstName.isEmpty && firebaseUser.displayName != null) {
          List<String> nameParts = firebaseUser.displayName!.trim().split(' ');
          firstName = nameParts.isNotEmpty ? nameParts.first : '';
          lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        }

        final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'firstName': firstName,
            'lastName': lastName,
            'email': firebaseUser.email ?? '',
            'photo': firebaseUser.photoURL ?? '',
            'createdAt': FieldValue.serverTimestamp(),
            'user_id': firebaseUser.uid,
            'type': "apple",
            'isUserBlock': false,
          });
        }

        await AppStorage.setString(AppStorage.userId, firebaseUser.uid);
        AppStorage.setLogin(true);

        hideLoaderDialog(context);
        showSnackBar(context, 'Apple Sign-In successful!', backgroundColor: AppColors.primary);
        ctx!.go(Routes.homeView);
      } else {
        hideLoaderDialog(context);
        showSnackBar(context, 'Apple Sign-In failed: No user returned', backgroundColor: Colors.red);
      }
    } catch (e) {
      hideLoaderDialog(context);
      log('❌ Error with Apple Sign-In: $e');
      showSnackBar(context, 'Apple Sign-In failed: ${e.toString()}', backgroundColor: Colors.red);
    }
  }
}
