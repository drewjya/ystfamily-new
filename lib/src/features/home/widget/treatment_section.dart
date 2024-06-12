import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/provider/category_provider.dart';

class TreatmentSection extends HookConsumerWidget {
  const TreatmentSection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.1,
        ),
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 12),
            child: Row(
              children: [
                Text(
                  "Treatment",
                  style: TextStyle(
                    color: VColor.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: categories.when(
                  data: (data) {
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, index) {
                        final treatment = data[index];
                        return Center(
                          child: VCard.vertical(
                              backgroundColor:
                                  VColor.appbarBackground.withOpacity(0.7),
                              height: 80,
                              onTap: () {
                                CabangRoute(tipe: treatment.nama).push(context);
                              },
                              child: Center(
                                child: Text(
                                  treatment.nama.replaceFirst(" ", "\n"),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: VColor.primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      itemCount: data.length,
                      scrollDirection: Axis.horizontal,
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
                )),
          )
        ],
      ),
    );
  }
}
