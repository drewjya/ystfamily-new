import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/model/category_model.dart';
import 'package:ystfamily/src/features/cabang/repository/cabang_repository_impl.dart';

class CategoryNotifier extends AsyncNotifier<List<CategoryTreatment>> {
  @override
  FutureOr<List<CategoryTreatment>> build() {
    return ref.read(cabangRepositoryProvider).getCategory();
  }
}

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<CategoryTreatment>>(
        CategoryNotifier.new);
