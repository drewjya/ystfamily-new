// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TResponse {
  final int status;
  final dynamic data;
  final dynamic error;
  final String message;
  TResponse({
    required this.status,
    required this.data,
    required this.error,
    required this.message,
  });

  TResponse copyWith({
    int? status,
    dynamic data,
    dynamic error,
    String? message,
  }) {
    return TResponse(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'data': data,
      'error': error,
      'message': message,
    };
  }

  factory TResponse.fromMap(Map<String, dynamic> map) {
    return TResponse(
      status: map['status'] as int,
      data: map['data'] as dynamic,
      error: map['error'] as dynamic,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TResponse.fromJson(String source) =>
      TResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TResponse(status: $status, data: $data, error: $error, message: $message)';
  }

  @override
  bool operator ==(covariant TResponse other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.data == data &&
        other.error == error &&
        other.message == message;
  }

  @override
  int get hashCode {
    return status.hashCode ^ data.hashCode ^ error.hashCode ^ message.hashCode;
  }
}
