import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/notification/model/notification_model.dart';
import 'package:ystfamily/src/features/notification/repository/notification_repository.dart';

class INotificationRepository implements NotificationRepository {
  final ApiRequest request;
  INotificationRepository({
    required this.request,
  });
  @override
  Future<List<NotificationM>> getNotificationList({required int limit, required int offset}) async {
    final res = await request.get(url: ApiPath.notificationList(limit, offset), isAuth: true);
    return (res.data as List).cast<Map<String, dynamic>>().map((e) => NotificationM.fromMap(e)).toList();
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return INotificationRepository(request: ref.read(requestProvider));
});
