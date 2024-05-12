import 'dart:developer';

import 'package:ystfamily/src/core/api/model/response_model.dart';

class ApiException implements Exception {
  final String message;
  final TResponse? response;
  ApiException({
    required this.message,
    this.response,
  });

  @override
  String toString() => 'ApiException(message: $message, response: $response)';

  @override
  bool operator ==(covariant ApiException other) {
    if (identical(this, other)) return true;

    return other.message == message && other.response == response;
  }

  @override
  int get hashCode => message.hashCode ^ response.hashCode;
}

String errorRoot(Object e) {
  if (e is ApiException) {
    if (e.response != null) {
      return e.response!.message;
    } else {
      return e.message;
    }
  } else {
    return 'Silahkan Coba Lagi';
  }
}

Map<String, dynamic> errorMap(Object e) {
  if (e is ApiException) {
    if (e.response != null) {
      log("${e.response!.error} EROR MAP");
      return e.response!.error;
    } else {
      return {'message': e.message};
    }
  } else {
    return {'message': 'Silahkan Coba Lagi'};
  }
}
