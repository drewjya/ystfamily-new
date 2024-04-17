import 'package:carousel_slider/carousel_slider.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/history/view/detail_history_screen.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];
final List<Widget> imageSliders = imgList
    .map((item) => Builder(builder: (context) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              child: InkWell(
                onTap: () {
                  showImageInteractive(context, item);
                },
                child: Image.network(
                  item,
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
            ),
          );
        }))
    .toList();

class CarouselHome extends StatelessWidget {
  const CarouselHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2,
              enlargeCenterPage: true,
            ),
            items: imageSliders,
          ),
        ),
      ],
    );
  }
}
