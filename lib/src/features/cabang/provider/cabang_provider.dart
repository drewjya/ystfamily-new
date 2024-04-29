// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';
import 'package:ystfamily/src/features/cabang/repository/cabang_repository_impl.dart';

class CabangNotifier extends FamilyAsyncNotifier<List<Cabang>, int?> {
  CabangNotifier();
  @override
  FutureOr<List<Cabang>> build(int? arg) {
    return ref.read(cabangRepositoryProvider).getCabang(categoryId: arg);
  }
}

final selectedCabangProvider = StateProvider<Cabang?>(
  (ref) => Cabang(
      cabangId: -1,
      nama: '',
      alamat: '',
      profilePicture: '',
      totalTreatment: -1,
      happyHourId: -1,
      startDay: -1,
      startTime: '',
      endDay: -1,
      endTime: '',
      totalMaleTherapist: -1,
      totalFemaleTherapist: -1),
);

final cabangProvider =
    AsyncNotifierProviderFamily<CabangNotifier, List<Cabang>, int?>(
  () => CabangNotifier(),
);
