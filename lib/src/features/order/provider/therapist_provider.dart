// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

class TherapistType {
  final int cabangId;
  final String tanggal;
  final String gender;

  TherapistType({
    required this.cabangId,
    required this.tanggal,
    required this.gender,
  });
}

class TherapistNotifier extends AsyncNotifier<List<Therapist>> {
  @override
  FutureOr<List<Therapist>> build() {
    return [];
  }

  load({required TherapistType arg}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(orderRepositoryProvider)
        .getTherapist(
            cabangId: arg.cabangId, tanggal: arg.tanggal, gender: arg.gender));
  }
}

final therapistProvider =
    AsyncNotifierProvider<TherapistNotifier, List<Therapist>>(
  () => TherapistNotifier(),
);
