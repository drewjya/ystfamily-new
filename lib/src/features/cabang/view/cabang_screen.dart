import 'package:collection/collection.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/cabang/provider/category_provider.dart';
import 'package:ystfamily/src/features/home/home.dart';

class CabangScreen extends HookConsumerWidget {
  const CabangScreen({
    super.key,
    required this.tipe,
  });
  final String tipe;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cabang ${tipe == "all" ? "" : tipe}",
        ),
        backgroundColor: VColor.appbarBackground,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Consumer(
          builder: (context, ref, child) {
            final category =
                (ref.watch(categoryProvider).value ?? []).firstWhereOrNull(
              (element) => element.nama == tipe,
            );

            final cabangData = ref.watch(cabangProvider(category?.id));
            return cabangData.when(
              data: (cabangs) {
                if (cabangs.isEmpty) {
                  return const Center(
                    child: Text("Belum Ada Cabang"),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.all(24),
                  itemCount: cabangs.length,
                  itemBuilder: (context, index) => CabangCard(
                      onTap: () {
                        OrderRoute(tipe: tipe, branch: cabangs[index].nama)
                            .push(context);
                      },
                      start: index != cabangs.length,
                      cabang: cabangs[index]),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text("$error"),
                );
              },
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
