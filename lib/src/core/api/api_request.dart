// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/api/model/response_model.dart';
import 'package:ystfamily/src/core/provider/pref_const.dart';
import 'package:ystfamily/src/core/provider/pref_provider.dart';

part 'api_request.g.dart';

enum Mode { post, put }

class ApiRequest {
  final SharedPreferences pref;
  ApiRequest({
    required this.pref,
  });

  Map<String, String> _authorization(
      {bool isAuth = true, bool isRefresh = false}) {
    if (isAuth) {
      if (isRefresh) {
        final auth = pref.getString(PrefConst.refreshToken);
        if (auth == null) {
          throw ApiException(message: "relogin");
        }
        return {
          "Authorization": "Bearer $auth",
        };
      }
      final auth = pref.getString(PrefConst.accessToken);
      if (auth == null) {
        throw ApiException(message: "unauthorized");
      }
      return {
        "Authorization": "Bearer $auth",
      };
    }
    return {};
  }

  Future<TResponse> get({
    required String url,
    bool isAuth = false,
    bool isRefresh = false,
  }) async {
    try {
      final header = _authorization(isAuth: isAuth, isRefresh: isRefresh);
      log("$header");
      final res = await http.get(Uri.parse(url), headers: header);
      log("++++++++++++++");
      log(url);
      log("$isRefresh $isAuth");
      final data = TResponse.fromJson(res.body);
      log("${data.status} ${data.message} ${data.error}");
      log("==============");

      if (data.status < 400) {
        return data;
      }
      throw ApiException(message: "", response: data);
    } on http.ClientException catch (e) {
      throw ApiException(message: e.message);
    } on TimeoutException {
      throw ApiException(message: "timeout");
    } on SocketException {
      throw ApiException(message: "check_connection");
    } on FormatException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TResponse> post(
      {required String url,
      Map<String, dynamic>? body,
      bool isRefresh = false,
      bool isAuth = false}) async {
    try {
      Map<String, String> header =
          _authorization(isAuth: isAuth, isRefresh: isRefresh);
      String? bod;
      if (body != null) {
        bod = jsonEncode(body);
        header["Content-Type"] = "application/json";
      }
      final req = await http.post(Uri.parse(url), headers: header, body: bod);

      final response = TResponse.fromJson(req.body);

      if (req.statusCode < 400) {
        return response;
      }

      throw ApiException(message: response.message, response: response);
    } on http.ClientException catch (e) {
      throw ApiException(message: e.message);
    } on TimeoutException {
      throw ApiException(message: "timeout");
    } on SocketException {
      throw ApiException(message: "check_connection");
    } on FormatException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TResponse> postWithImage(
      {required String url,
      Map<String, String>? body,
      Map<String, XFile>? bodyImage,
      bool isRefresh = false,
      Mode mode = Mode.post,
      bool isAuth = false}) async {
    try {
      Map<String, String> header =
          _authorization(isAuth: isAuth, isRefresh: isRefresh);
      Map<String, String> bod = {};
      if (body != null) {
        bod = body;
        header["Content-Type"] = "application/json";
      }

      var request = http.MultipartRequest(
        mode == Mode.post ? 'POST' : "PUT",
        Uri.parse(url),
      );
      request.headers.addAll(header);
      request.fields.addAll(bod);
      if (bodyImage != null) {
        for (var i = 0; i < bodyImage.length; i++) {
          final key = bodyImage.keys.elementAt(i);
          final value = bodyImage.values.elementAt(i);
          log("${value.name} VAL PATH");
          if (kIsWeb || value.path.trim().isEmpty) {
            final ext = value.name.split('.').last;
            final name = value.name.split('.');
            final fixName = name.sublist(0, name.length - 1).join('.');
            log(ext);
            request.files.add(http.MultipartFile.fromBytes(
                key, await value.readAsBytes(),
                filename: fixName, contentType: MediaType('image', ext)));
          } else {
            request.files
                .add(await http.MultipartFile.fromPath(key, value.path));
          }
        }
      }
      final send = await request.send();
      final req = await http.Response.fromStream(send);

      // final req = await http.post(Uri.parse(url), headers: header, body: bod);

      final response = TResponse.fromJson(req.body);
      if (req.statusCode < 400) {
        return response;
      }

      throw ApiException(message: response.message, response: response);
    } on http.ClientException catch (e) {
      throw ApiException(message: e.message);
    } on TimeoutException {
      throw ApiException(message: "timeout");
    } on SocketException {
      throw ApiException(message: "check_connection");
    } on FormatException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TResponse> put(
      {required String url,
      Object? body,
      bool isAuth = true,
      Map<String, String>? headers}) async {
    try {
      var header = _authorization(isAuth: isAuth, isRefresh: false);
      if (headers != null) {
        header.addAll(headers);
      }

      final req = await http.put(Uri.parse(url), headers: header, body: body);

      final response = TResponse.fromJson(req.body);
      if (req.statusCode < 400) {
        return response;
      }

      throw ApiException(message: "", response: response);
    } on http.ClientException catch (e) {
      throw ApiException(message: e.message);
    } on TimeoutException {
      throw ApiException(message: "timeout");
    } on SocketException {
      throw ApiException(message: "check_connection");
    } on FormatException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<TResponse> delete({
    required String url,
    Map<String, dynamic>? body,
    bool isAuth = true,
  }) async {
    try {
      Map<String, String> header =
          _authorization(isAuth: isAuth, isRefresh: false);

      final req =
          await http.delete(Uri.parse(url), headers: header, body: body);
      final response = TResponse.fromJson(req.body);
      if (req.statusCode < 400) {
        return response;
      }

      throw ApiException(message: "", response: response);
    } on http.ClientException catch (e) {
      throw ApiException(message: e.message);
    } on TimeoutException {
      throw ApiException(message: "timeout");
    } on SocketException {
      throw ApiException(message: "check_connection");
    } on FormatException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
ApiRequest request(RequestRef ref) {
  return ApiRequest(pref: ref.watch(prefProvider));
}
