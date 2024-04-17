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
