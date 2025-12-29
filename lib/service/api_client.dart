import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../helper/shared_prefe/shared_prefe.dart';
import 'api_check.dart';
import 'api_url.dart';

class ApiClient extends GetxService {
  final http.Client client = http.Client();

  static const int timeoutInSeconds = 30;
  static const String noInternetMessage = "Can't connect to the internet!";

  Future<Map<String, String>> _header({bool needToken = true}) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json', //  MUST
    };



    if (needToken) {
      final token = await SharePrefsHelper.getString(ApiConstant.bearerToken);
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }


  /// ================= GET =================
  Future<Response> getData(String uri) async {
    try {
      final response = await client
          .get(
        Uri.parse(ApiConstant.baseUrl + uri),
        headers: await _header(),
      )
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _handleResponse(response, uri);
      print(response);
    } catch (_) {
      return const Response(statusCode: 0, statusText: noInternetMessage);
    }
  }

  /// ================= POST =================
  Future<Response> postData(
      String uri,
      dynamic body, {
        bool needToken = true,
      }) async {
    try {
      debugPrint("REQUEST BODY => ${jsonEncode(body)}");

      final response = await client
          .post(
        Uri.parse(ApiConstant.baseUrl + uri),
        headers: await _header(needToken: needToken),
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: timeoutInSeconds));

      return _handleResponse(response, uri);
    } catch (_) {
      return const Response(
        statusCode: 0,
        statusText: noInternetMessage,
      );
    }
  }


  /// ================= MULTIPART =================
  Future<Response> postMultipartData(
      String uri,
      Map<String, String> body,
      List<MultipartBody> files,
      ) async {
    try {
      final request =
      http.MultipartRequest('POST', Uri.parse(ApiConstant.baseUrl + uri));

      request.headers.addAll(await _header());
      request.fields.addAll(body);

      for (final file in files) {
        final mime = lookupMimeType(file.file.path) ?? 'image/jpeg';
        request.files.add(
          await http.MultipartFile.fromPath(
            file.key,
            file.file.path,
            contentType: MediaType.parse(mime),
          ),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      return _handleResponse(response, uri);
    } catch (_) {
      return const Response(statusCode: 0, statusText: noInternetMessage);
    }
  }

  /// ================= HANDLE RESPONSE =================
  Response _handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = response.body;
    }

    final res = Response(
      statusCode: response.statusCode,
      body: body,
      statusText: response.reasonPhrase,
    );

    ApiChecker.checkApi(res);

    debugPrint(
        '====> API [$uri] [${res.statusCode}] \n${res.body}');
    return res;
  }
}

/// ================= MULTIPART MODEL =================
class MultipartBody {
  final String key;
  final File file;
  MultipartBody(this.key, this.file);
}
