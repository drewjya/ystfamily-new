// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/order/model/time_slot.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

class TimeSlotParam {
  final int? therapistId;
  final int cabangId;
  final String tanggal;
  TimeSlotParam({
    this.therapistId,
    required this.cabangId,
    required this.tanggal,
  });

  TimeSlotParam copyWith({
    int? therapistId,
    int? cabangId,
    String? tanggal,
  }) {
    return TimeSlotParam(
      therapistId: therapistId ?? this.therapistId,
      cabangId: cabangId ?? this.cabangId,
      tanggal: tanggal ?? this.tanggal,
    );
  }

  @override
  String toString() =>
      'TimeSlotParam(therapistId: $therapistId, cabangId: $cabangId, tanggal: $tanggal)';

  @override
  bool operator ==(covariant TimeSlotParam other) {
    if (identical(this, other)) return true;

    return other.therapistId == therapistId &&
        other.cabangId == cabangId &&
        other.tanggal == tanggal;
  }

  @override
  int get hashCode =>
      therapistId.hashCode ^ cabangId.hashCode ^ tanggal.hashCode;
}

class TimeSlotNotifier
    extends AutoDisposeFamilyAsyncNotifier<TimeSlot?, TimeSlotParam?> {
  @override
  FutureOr<TimeSlot?> build(TimeSlotParam? arg) {
    if (arg == null) {
      return null;
    }
    return ref.read(orderRepositoryProvider).getTimeSlot(
        cabangId: arg.cabangId,
        tanggal: arg.tanggal,
        therapistId: arg.therapistId);
  }
}

final timeslotProvider = AutoDisposeAsyncNotifierProviderFamily<
    TimeSlotNotifier, TimeSlot?, TimeSlotParam?>(
  () => TimeSlotNotifier(),
);
