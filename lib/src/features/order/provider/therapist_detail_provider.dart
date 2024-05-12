import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/order/model/therapist_detail.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

class TherapistDetailNotifier
    extends AutoDisposeFamilyAsyncNotifier<TherapistDetail?, int?> {
  @override
  FutureOr<TherapistDetail?> build(int? arg) {
    if (arg != null) {
      return ref
          .read(orderRepositoryProvider)
          .getTherapistDetail(therapistId: arg);
    }
    return null;
  }
}

final therapistDetailProvider = AutoDisposeAsyncNotifierProviderFamily<
    TherapistDetailNotifier,
    TherapistDetail?,
    int?>(TherapistDetailNotifier.new);
