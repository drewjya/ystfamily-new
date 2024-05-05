import 'package:ystfamily/src/features/cabang/model/category_model.dart';
import 'package:ystfamily/src/features/cabang/model/model.dart';

abstract class CabangRepository {
  Future<List<Cabang>> getCabang({required String categoryName});
  Future<List<CategoryTreatment>> getCategory();

  Future<List<Cabang>> getCabangLimit({int? limit});
}
