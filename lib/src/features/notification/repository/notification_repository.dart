import 'package:ystfamily/src/features/notification/model/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationM>> getNotificationList({required int limit, required int offset});
}
