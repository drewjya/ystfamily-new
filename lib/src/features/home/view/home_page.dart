import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';

import '../widget/treatment_section.dart';
import '../widget/widget.dart';

// enum Category{

// }

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAuthHook(ref: ref, context: context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(cabangProvider);
              },
              child: ListView.separated(
                itemCount: 4,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 12,
                  );
                },
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CarouselHome();
                  }

                  if (index == 1) {
                    return const CabangSection();
                  }
                  if (index == 2) {
                    return const TreatmentSection();
                  }

                  return const SizedBox(
                    height: 12,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
