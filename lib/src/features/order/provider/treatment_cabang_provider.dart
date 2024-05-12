import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/features/order/model/treatment_model.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

class TreatmentCabangNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<TreatmentCabang>, int> {
  @override
  FutureOr<List<TreatmentCabang>> build(int arg) {
    return ref.read(orderRepositoryProvider).getTreatmentCabang(cabangId: arg);
  }
}

final treatmentCabangProvider = AutoDisposeAsyncNotifierProviderFamily<
    TreatmentCabangNotifier,
    List<TreatmentCabang>,
    int>(TreatmentCabangNotifier.new);
