import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';

abstract class BannerRepository {
  Future<List<String>> getBanners();
}

class IBannerRepository implements BannerRepository {
  final ApiRequest request;
  IBannerRepository({
    required this.request,
  });

  @override
  Future<List<String>> getBanners() async {
    final res = await request.get(
        url: BannerPath.banner, isAuth: true, isRefresh: false);
    return ((res.data as List?) ?? []).cast<Map<String, dynamic>>().map((e) {
      log("$e");
      return '${e['picture']}';
    }).toList();
  }
}

final bannerRepository = Provider<BannerRepository>((ref) {
  return IBannerRepository(request: ref.read(requestProvider));
});
