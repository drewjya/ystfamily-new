// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';
import 'package:ystfamily/src/features/cabang/repository/cabang_repository_impl.dart';

class CabangNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Cabang>, int?> {
  CabangNotifier();
  @override
  FutureOr<List<Cabang>> build(int? arg) {
    return ref.read(cabangRepositoryProvider).getCabangLimit(limit: arg);
  }
}

class CabangCategoryNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Cabang>, String> {
  CabangCategoryNotifier();
  @override
  FutureOr<List<Cabang>> build(String arg) {
    return ref.read(cabangRepositoryProvider).getCabang(categoryName: arg);
  }
}

final selectedCabangProvider = StateProvider<Cabang?>((ref) => null);

final cabangProvider =
    AutoDisposeAsyncNotifierProviderFamily<CabangNotifier, List<Cabang>, int?>(
  () => CabangNotifier(),
);
final cabangCategoryProvider = AutoDisposeAsyncNotifierProviderFamily<
    CabangCategoryNotifier, List<Cabang>, String>(
  () => CabangCategoryNotifier(),
);
