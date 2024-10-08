import 'package:collection/collection.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/cabang/provider/cabang_provider.dart';
import 'package:ystfamily/src/features/home/widget/customize_cabang.dart';

class CabangSection extends ConsumerWidget {
  const CabangSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return Container(
      padding: const EdgeInsets.only(bottom: 20).copyWith(left: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Cabang",
                style: TextStyle(
                  color: VColor.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    const CabangRoute(tipe: "all").push(context);
                  },
                  child: const Text("Lihat Semua"))
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: ref.watch(cabangProvider(2)).when(
                  loading: () {
                    return [const LoadingWidget()];
                  },
                  error: (error, stackTrace) {
                    return [
                      Text(
                        "$error error",
                      )
                    ];
                  },
                  data: (data) {
                    return data
                        .mapIndexed(
                          (index, e) => CustomizeCabang(
                            cabang: e,
                            start: index != 2,
                            onTap: (cabang) {
                              if (auth.asData?.value != null) {
                                OrderRoute(branch: cabang.nama).push(context);
                              } else {
                                authDialog(context);
                              }
                            },
                          ),
                        )
                        .toList();
                  },
                ),
              )),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
