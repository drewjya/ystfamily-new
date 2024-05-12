// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/core/provider/banner_provider.dart';
import 'package:ystfamily/src/features/home/home.dart';

class ImageSliders extends StatelessWidget {
  final String url;
  const ImageSliders({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: 800.0,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress?.cumulativeBytesLoaded !=
                loadingProgress?.expectedTotalBytes) {
              return Center(
                child: LinearProgressIndicator(
                  minHeight: 120,
                  value: (loadingProgress?.cumulativeBytesLoaded ?? 0) /
                      (loadingProgress?.expectedTotalBytes ?? 1),
                ),
              );
            }
            return child;
          },
        ),
      ),
    );
  }
}

class CarouselHome extends ConsumerWidget {
  const CarouselHome({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Stack(
      children: [
        Container(
          height: (MediaQuery.sizeOf(context).height * 0.15),
          decoration: const BoxDecoration(
            color: VColor.appbarBackground,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12).copyWith(bottom: 0),
          // height: MediaQuery.sizeOf(context).height * 0.21,
          width: double.infinity,
          child: ref.watch(bannerProvider).when(
            data: (data) {
              return CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2,
                  enlargeCenterPage: true,
                ),
                items: data.map((e) {
                  log(image + e);
                  final url = image + e;
                  return ImageSliders(url: url);
                }).toList(),
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Text('$error'),
              );
            },
            loading: () {
              return const Center(child: LoadingWidget());
            },
          ),
        ),
      ],
    );
  }
}
