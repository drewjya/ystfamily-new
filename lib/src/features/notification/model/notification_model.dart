// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationM {
  final String title;
  final String description;
  final String createdAt;
  NotificationM({
    required this.title,
    required this.description,
    required this.createdAt,
  });

  NotificationM copyWith({
    String? title,
    String? description,
    String? createdAt,
  }) {
    return NotificationM(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory NotificationM.fromMap(Map<String, dynamic> map) {
    return NotificationM(
      title: map['title'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationM.fromJson(String source) => NotificationM.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NotificationM(title: $title, description: $description, createdAt: $createdAt)';

  @override
  bool operator ==(covariant NotificationM other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.description == description &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ createdAt.hashCode;
}
