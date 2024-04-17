// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';
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
  Future<List<Cabang>> getCabang({int? categoryId}) async {
    String params = "${categoryId ?? ""}";

    final res = await request.get(url: ApiPath.cabang + params, isAuth: true, isRefresh: false);
    return (res.data as List).cast<Map<String, dynamic>>().map((e) => Cabang.fromMap(e)).toList();
  }

  @override
  Future<List<CategoryTreatment>> getCategoryTreatment() async {
    final res = await request.get(url: ApiPath.category, isAuth: true, isRefresh: false);
    return (res.data as List).cast<Map<String, dynamic>>().map((e) => CategoryTreatment.fromMap(e)).toList();
  }
}

final cabangRepositoryProvider = Provider<CabangRepository>((ref) {
  return CabangRepositoryImpl(request: ref.read(requestProvider));
});
