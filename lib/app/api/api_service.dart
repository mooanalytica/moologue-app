import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moo_logue/app/core/storage/get_storage.dart';
import 'package:moo_logue/app/routes/index.js.dart';
import 'package:moo_logue/app/widgets/app_snackbar.dart';

import 'api_constant.dart';

class APIService {
  Dio dio = Dio();

  Dio get sendRequest => dio;

  Map<String, dynamic> header = {
    // "Authorization": "Bearer ${preferences.getString(SharedPreference.accessToken)}",
    if (AppStorage.getString(AppStorage.accessToken) != null && AppStorage.getString(AppStorage.accessToken) != "")
      "Authorization": "Bearer ${AppStorage.getString(AppStorage.accessToken)}",
    'Content-Type': 'application/json',
    "Accept": '*/*',
    // 'Accept-Encoding': 'gzip, deflate, br',br
  };

  Map<String, dynamic> multipartHeader = {
    if (AppStorage.getString(AppStorage.accessToken) != null && AppStorage.getString(AppStorage.accessToken) != "")
      // "Authorization": "Bearer ${preferences.getString(SharedPreference.accessToken)}",
      "Authorization": "Bearer ${AppStorage.getString(AppStorage.accessToken)}",
    'Content-Type': 'multipart/form-data',
    'Accept': '*/*',
    // 'Accept-Encoding': 'gzip, deflate, br',
  };

  APIService() {
    dio.options = BaseOptions(
      baseUrl: AppUrls.baseURL,
      connectTimeout: AppUrls.responseTimeOut,
      receiveTimeout: AppUrls.responseTimeOut,
      sendTimeout: AppUrls.responseTimeOut,
      responseType: ResponseType.json,
      headers: header,
    );
  }

  Future<Response?> getAPI({
    required String url,
    required BuildContext context,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isMultipart = false,
    ResponseType? responseType,
  }) async {
    try {
      Response response = await dio.get(
        url,
        data: isMultipart == true ? FormData.fromMap(body ?? {}) : body ?? {},
        queryParameters: queryParameters,
        options: Options(headers: isMultipart == true ? multipartHeader : header, responseType: responseType ?? ResponseType.json),
      );

      return handleResponse(
        response: response,
        url:
            "Get API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${response.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${response.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${response.data}",
        context: context,
      );
    } on DioException catch (exception) {
      if (exception.response != null) {
        return handleResponse(
          response: exception.response!,
          url:
              "Get API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
          context: context,
        );
      } else {
        log(
          "Get API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
        );

        showSnackBar(context, "Something went wrong. Please try again.", backgroundColor: Colors.red);

        return null;
      }
    } on TimeoutException {
      showSnackBar(context, "TimeOut while connecting to server please try again", backgroundColor: Colors.red);

      return null;
    } on SocketException {
      showSnackBar(context, "Check your internet connection", backgroundColor: Colors.red);

      return null;
    } catch (ex) {
      log("Get API URL :::::::: ${AppUrls.baseURL}$url\n    API Exception :::::::::::::::: $ex");
      return null;
    }
  }

  Future<Response?> postAPI({
    required String url,
    required BuildContext context,
    // Map<String, dynamic>? body,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool? isMultipart = false,
  }) async {
    try {
      Response response = await dio.post(
        url,
        data: isMultipart == true ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: isMultipart == true ? multipartHeader : header),
      );
      print('response==========>>>>>${response.statusCode}');
      return handleResponse(
        response: response,
        url:
            "POST API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${response.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${response.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${response.data}",
        context: context,
      );
    } on DioException catch (exception) {
      if (exception.response != null) {
        return handleResponse(
          response: exception.response!,
          url:
              "POST API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
          context: context,
        );
      } else {
        log(
          "POST API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
        );
        showSnackBar(ctx!, "Something went wrong. Please try again.");
      }
      return null;
    } on TimeoutException {
      showSnackBar(context, "TimeOut while connecting to server please try again", backgroundColor: Colors.red);

      return null;
    } on SocketException {
      showSnackBar(context, "Check your internet connection", backgroundColor: Colors.red);

      return null;
    } catch (ex) {
      log("POST API URL :::::::: ${AppUrls.baseURL}$url\n    API Exception :::::::::::::::: $ex");
      return null;
    }
  }

  Future<Response?> putAPI({
    required String url,
    required BuildContext context,
    // Map<String, dynamic>? body,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool? isMultipart = false,
  }) async {
    try {
      Response response = await dio.put(
        url,
        data: isMultipart == true ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: isMultipart == true ? multipartHeader : header),
      );

      return handleResponse(
        response: response,
        url:
            "PUT API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${response.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${response.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${response.data}",
        context: context,
      );
    } on DioException catch (exception) {
      if (exception.response != null) {
        return handleResponse(
          response: exception.response!,
          url:
              "PUT API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
          context: context,
        );
      } else {
        showSnackBar(context, "Something went wrong. Please try again.");

        log(
          "PUT API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
        );
      }
      return null;
    } on TimeoutException {
      showSnackBar(context, "TimeOut while connecting to server please try again", backgroundColor: Colors.red);

      return null;
    } on SocketException {
      showSnackBar(context, "Check your internet connection", backgroundColor: Colors.red);

      return null;
    } catch (ex) {
      log("PUT API URL :::::::: ${AppUrls.baseURL}$url\n    API Exception :::::::::::::::: $ex");
      return null;
    }
  }

  Future<Response?> patchAPI({
    required BuildContext context,
    required String url,
    // Map<String, dynamic>? body,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    bool? isMultipart = false,
  }) async {
    try {
      Response response = await dio.patch(
        url,
        data: isMultipart == true ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: isMultipart == true ? multipartHeader : header),
      );

      return handleResponse(
        response: response,
        url:
            "PATCH API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${response.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${response.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${response.data}",
        context: context,
      );
    } on DioException catch (exception) {
      if (exception.response != null) {
        return handleResponse(
          response: exception.response!,
          url:
              "PATCH API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
          context: context,
        );
      } else {
        showSnackBar(context, "Something went wrong. Please try again.", backgroundColor: Colors.red);

        log(
          "PATCH API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
        );
      }
      return null;
    } on TimeoutException {
      showSnackBar(context, "TimeOut while connecting to server please try again", backgroundColor: Colors.red);
      return null;
    } on SocketException {
      showSnackBar(context, "Check your internet connection", backgroundColor: Colors.red);

      return null;
    } catch (ex) {
      log("PATCH API URL :::::::: ${AppUrls.baseURL}$url\n    API Exception :::::::::::::::: $ex");
      return null;
    }
  }

  Future<Response?> deleteAPI({
    required BuildContext context,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? isMultipart = false,
  }) async {
    try {
      Response response = await dio.delete(
        url,
        data: isMultipart == true ? FormData.fromMap(body ?? {}) : body,
        queryParameters: queryParameters,
        options: Options(headers: isMultipart == true ? multipartHeader : header),
      );

      return handleResponse(
        response: response,
        url:
            "DELETE API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${response.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${response.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${response.data}",
        context: context,
      );
    } on DioException catch (exception) {
      if (exception.response != null) {
        return handleResponse(
          response: exception.response!,
          url:
              "DELETE API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
          context: context,
        );
      } else {
        log(
          "DELETE API URL :::::::: ${AppUrls.baseURL}$url\n    API REQUEST HEADER :::::::::::::::: ${exception.response?.requestOptions.headers}\n    API REQUEST :::::::::::::::: ${exception.response?.requestOptions.data}\n    API RESPONSE :::::::::::::::: ${exception.response?.data}",
        );
        showSnackBar(context, "Something went wrong. Please try again.", backgroundColor: Colors.red);
      }
      return null;
    } on TimeoutException {
      showSnackBar(context, "TimeOut while connecting to server please try again", backgroundColor: Colors.red);

      return null;
    } on SocketException {
      showSnackBar(context, "Check your internet connection", backgroundColor: Colors.red);

      return null;
    } catch (ex) {
      log("DELETE API URL :::::::: ${AppUrls.baseURL}$url\n    API Exception :::::::::::::::: $ex");
      return null;
    }
  }

  Future<Response?> handleResponse({required Response response, required String url, required BuildContext context}) async {
    log(url);

    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
        return response;
      case 302:
      case 400:
        showSnackBar(context, response.data["message"], backgroundColor: Colors.red);

        return null;
      case 401:
        // AppHelper.appLogout();
        showSnackBar(context, response.data["message"], backgroundColor: Colors.red);

        // AppHelper.showSnackBar(message: response.data["message"]);
        return null;
      case 413:
        // AppHelper.appLogout();
        showSnackBar(context, response.data["message"], backgroundColor: Colors.red);

        // AppHelper.showSnackBar(message: response.data["message"]);
        return null;
      case 500:
        showSnackBar(context, response.data["message"] ?? response.data["error"], backgroundColor: Colors.red);

        return null;
      case 502:
        showSnackBar(context, response.data["message"], backgroundColor: Colors.red);

        return null;
      default:
        return null;
    }
  }
}
