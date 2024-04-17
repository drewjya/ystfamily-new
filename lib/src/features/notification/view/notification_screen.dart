import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/notification/provider/list_notification_provider.dart';

class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future.microtask(() => ref.refresh(notificationListProvider));
      return;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        backgroundColor: VColor.primaryBackground,
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white,
          child: ref.watch(notificationListProvider).when(
                skipLoadingOnRefresh: false,
                skipLoadingOnReload: false,
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(child: Text("Tidak ada notifikasi"));
                  }
                  return ListView.separated(
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    separatorBuilder: (context, index) {
                      return const Gap(12);
                    },
                    itemBuilder: (context, index) {
                      final curr = data[index];
                      return Container(
                        padding: const EdgeInsets.all(8),
                        color: VColor.primaryBackground,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  curr.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: VColor.primaryTextColor,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  DateTime.parse(curr.createdAt).formatTimeAgo(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                            Text(curr.message)
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text(error.toString()),
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )),
    );
  }
}
