// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ystfamily/src/features/auth/model/user.dart';

class Session {
  final String accessToken;
  final String refreshToken;
  Session({
    required this.accessToken,
    required this.refreshToken,
  });

  Session copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return Session(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Session(accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  bool operator ==(covariant Session other) {
    if (identical(this, other)) return true;

    return other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}

class AuthResponse {
  final User account;
  final Session session;
  AuthResponse({
    required this.account,
    required this.session,
  });

  AuthResponse copyWith({
    User? account,
    Session? session,
  }) {
    return AuthResponse(
      account: account ?? this.account,
      session: session ?? this.session,
    );
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      account: User.fromMap(map['user'] as Map<String, dynamic>),
      session: Session.fromMap(map['token'] as Map<String, dynamic>),
    );
  }

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AuthResponse(account: $account, session: $session)';

  @override
  bool operator ==(covariant AuthResponse other) {
    if (identical(this, other)) return true;

    return other.account == account && other.session == session;
  }

  @override
  int get hashCode => account.hashCode ^ session.hashCode;
}
