import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/order/provider/detail_order_provider.dart';
import 'package:ystfamily/src/features/order/provider/order_provider.dart';

class RescheduleOrderScreen extends HookConsumerWidget {
  final int id;
  const RescheduleOrderScreen({
    required this.id,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailOrder = ref.watch(detailOrderProvider(id));
    final isLoading = useState(false);

    ref.listen(orderProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data.isEmpty) {
            return;
          }
          if (data.isNotEmpty) {
            if (isLoading.value) {
              isLoading.value = false;
              Navigator.pop(context);
            }
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Berhasil Kirim Bukti Pembayaran")));
            ref.invalidate(detailOrderProvider(id));
          }
        },
        error: (error, stackTrace) {
          if (isLoading.value) {
            isLoading.value = false;
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        },
        loading: () {
          isLoading.value = true;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    });
    return Scaffold();
  }
}
