// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';
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

  Future load(
      {required String name,
      required int cabangId,
      required Gender gender}) async {
    state = const AsyncLoading();
    final value = await AsyncValue.guard(() => ref
        .read(orderRepositoryProvider)
        .queryTherapist(name: name, gender: gender, cabangId: cabangId));
    state = value;
  }
}

final therapistProvider =
    AsyncNotifierProvider<TherapistNotifier, List<Therapist>>(
  () => TherapistNotifier(),
);
