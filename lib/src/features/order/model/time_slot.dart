// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';

class TimeSlot {
  final String timeOpen;
  final String timeClose;
  final List<String> timeSlot;
  TimeSlot({
    required this.timeOpen,
    required this.timeClose,
    required this.timeSlot,
  });

  TimeSlot copyWith({
    String? timeOpen,
    String? timeClose,
    List<String>? timeSlot,
  }) {
    return TimeSlot(
      timeOpen: timeOpen ?? this.timeOpen,
      timeClose: timeClose ?? this.timeClose,
      timeSlot: timeSlot ?? this.timeSlot,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timeOpen': timeOpen,
      'timeClose': timeClose,
      'timeSlot': timeSlot,
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    log("$map TIMSLOT");
    return TimeSlot(
      timeOpen: map['timeOpen'] as String,
      timeClose: map['timeClose'] as String,
      timeSlot: (map["timeSlot"] as List).map((e) => "$e").toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlot.fromJson(String source) =>
      TimeSlot.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TimeSlot(timeOpen: $timeOpen, timeClose: $timeClose, timeSlot: $timeSlot)';

  @override
  bool operator ==(covariant TimeSlot other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.timeOpen == timeOpen &&
        other.timeClose == timeClose &&
        listEquals(other.timeSlot, timeSlot);
  }

  @override
  int get hashCode =>
      timeOpen.hashCode ^ timeClose.hashCode ^ timeSlot.hashCode;
}
