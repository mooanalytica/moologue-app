class AppUrls {
  /// API BASE URL

  static const baseURL =
   "https://us-central1-moologue.cloudfunctions.net/api/";
  // static const socketBaseURL =
  //     // "https://beliveapi.happymushroom-0597bc74.eastus2.azurecontainerapps.io";
  //     "http://192.168.29.24:3000";

  static const Duration responseTimeOut = Duration(seconds: 60);
  // static const baseURLImage = "http://192.168.29.24:3000";
  // static const baseURLStream = "${baseURL}stream/";

  /// auth url
  static const sendOtp = "send-otp";
  static const verifyOtp = "verify-otp";
  static const uploadProfile = "update-user-profile";
  static const deleteFiles = "delete-files";

}
