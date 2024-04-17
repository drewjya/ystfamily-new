// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationM {
  final int notificationId;
  final int accountId;
  final String title;
  final String message;
  final String createdAt;
  final String updatedAt;
  final bool isRead;
  NotificationM({
    required this.notificationId,
    required this.accountId,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
  });

  NotificationM copyWith({
    int? notificationId,
    int? accountId,
    String? title,
    String? message,
    String? createdAt,
    String? updatedAt,
    bool? isRead,
  }) {
    return NotificationM(
      notificationId: notificationId ?? this.notificationId,
      accountId: accountId ?? this.accountId,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notification_id': notificationId,
      'account_id': accountId,
      'title': title,
      'message': message,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_read': isRead,
    };
  }

  factory NotificationM.fromMap(Map<String, dynamic> map) {
    return NotificationM(
      notificationId: map['notification_id'].toInt() as int,
      accountId: map['account_id'].toInt() as int,
      title: map['title'] as String,
      message: map['message'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      isRead: map['is_read'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationM.fromJson(String source) => NotificationM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationM(notificationId: $notificationId, accountId: $accountId, title: $title, message: $message, createdAt: $createdAt, updatedAt: $updatedAt, isRead: $isRead)';
  }

  @override
  bool operator ==(covariant NotificationM other) {
    if (identical(this, other)) return true;
  
    return 
      other.notificationId == notificationId &&
      other.accountId == accountId &&
      other.title == title &&
      other.message == message &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.isRead == isRead;
  }

  @override
  int get hashCode {
    return notificationId.hashCode ^
      accountId.hashCode ^
      title.hashCode ^
      message.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      isRead.hashCode;
  }
}
