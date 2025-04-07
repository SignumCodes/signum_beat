import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

abstract class BaseClient {
  final BaseOptions? options;
  final Dio dio;
  BaseClient([this.options])
      : dio = Dio(
          options ??
              BaseOptions(
                baseUrl: 'https://www.jiosaavn.com/api.php',
                queryParameters: {
                  '_format': 'json',
                  '_marker': '0',
                  'ctx': 'wap6dot0',
                },
                responseType: ResponseType.json,
              ),
        );

  Future<Map<String, dynamic>> request({
    /// Use [endpoints] from [lib/collection/endpoints.dart]
    required String call,
    bool isAPIv4 = false,
    String language = 'hindi',
    Map<String, dynamic>? queryParameters,
  }) async {
    // Build the request URL and payload for debugging
    final requestUrl = dio.options.baseUrl + "/";
    final requestPayload = {
      if (isAPIv4) 'api_version': 4,
      '__call': call,
      ...?queryParameters,
    };

    // Print request URL and payload
    log("Request URL: $requestUrl");
    log("Request Payload: $requestPayload");
    const userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36";

    final res = await dio.get(
      "/",
      queryParameters: requestPayload,
      options: Options(
        headers: {
          "cookie":
          'L=${Uri.encodeComponent(language)}; gdpr_acceptance=true; DL=english',
          "User-Agent": userAgent,
        },
      ),
    );

    // Print response URL and data
    log("Response URL: ${res.realUri}");
    log("Response Data: ${res.data}");

    if (res.data is String) {
      return jsonDecode(res.data) as Map<String, dynamic>;
    } else if (res.data is Map<String, dynamic>) {
      return res.data as Map<String, dynamic>;
    } else {
      throw Exception('Unexpected response type: ${res.data.runtimeType}');
    }
  }
 Future<List> requestReco({
    /// Use [endpoints] from [lib/collection/endpoints.dart]
    required String call,
    bool isAPIv4 = false,
    String language = 'hindi',
    Map<String, dynamic>? queryParameters,
  }) async {
    // Build the request URL and payload for debugging
    final requestUrl = dio.options.baseUrl + "/";
    final requestPayload = {
      if (isAPIv4) 'api_version': 4,
      '__call': call,
      ...?queryParameters,
    };

    // Print request URL and payload
    log("Request URL: $requestUrl");
    log("Request Payload: $requestPayload");
    const userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
        "(KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36";

    final res = await dio.get(
      "/",
      queryParameters: requestPayload,
      options: Options(
        headers: {
          "cookie":
          'L=${Uri.encodeComponent(language)}; gdpr_acceptance=true; DL=english',
          "User-Agent": userAgent,
          // "Referrer Policy":"strict-origin-when-cross-origin",
          // ":authority:":"www.jiosaavn.com",
          // ":method:" : "GET",
          // ":path:" : "/api.php?_format=json&_marker=0&ctx=wap6dot0&__call=webapi.getLaunchData",
        },
      ),
    );

    // Print response URL and data
    log("Response URL: ${res.realUri}");
    log("Response Data: ${res.data}");

    return jsonDecode(res.data) as List<dynamic>;
  }



}
