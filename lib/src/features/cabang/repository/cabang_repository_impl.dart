// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/model/cabang_model.dart';
import 'package:ystfamily/src/features/cabang/model/category_model.dart';
import 'package:ystfamily/src/features/cabang/repository/cabang_repository.dart';

class CabangRepositoryImpl implements CabangRepository {
  final ApiRequest request;
  CabangRepositoryImpl({
    required this.request,
  });
  @override
  Future<List<Cabang>> getCabang({required String categoryName}) async {
    final res = await request.get(
        url: CabangPath.getCabangCategory(categoryName),
        isAuth: false,
        isRefresh: false);
    return (res.data as List)
        .cast<Map<String, dynamic>>()
        .map((e) => Cabang.fromMap(e))
        .toList();
  }

  @override
  Future<List<CategoryTreatment>> getCategory() async {
    final res = await request.get(
        url: CategoryPath.category, isAuth: false, isRefresh: false);
    return (res.data as List)
        .cast<Map<String, dynamic>>()
        .map((e) => CategoryTreatment.fromMap(e))
        .toList();
  }

  @override
  Future<List<Cabang>> getCabangLimit({int? limit}) async {
    final queryParam = "?limit=${limit ?? ""}";
    log(CabangPath.cabang + queryParam);
    final res =
        await request.get(url: CabangPath.cabang + queryParam, isAuth: false);
    return (res.data as List)
        .cast<Map<String, dynamic>>()
        .map((e) => Cabang.fromMap(e))
        .toList();
  }
}

final cabangRepositoryProvider = Provider<CabangRepository>((ref) {
  return CabangRepositoryImpl(request: ref.read(requestProvider));
});
