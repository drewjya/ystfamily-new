import 'package:ystfamily/src/features/cabang/model/category_model.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';

abstract class CabangRepository {
  Future<List<Cabang>> getCabang({int? categoryId});
  Future<List<CategoryTreatment>> getCategoryTreatment();
}
