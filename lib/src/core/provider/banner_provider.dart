import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ystfamily/src/core/repository/banner_repository.dart';

part 'banner_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> banner(BannerRef ref) async {
  return ref.read(bannerRepository).getBanners();
}
