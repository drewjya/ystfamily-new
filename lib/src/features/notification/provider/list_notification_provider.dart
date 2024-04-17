import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/notification/model/notification_model.dart';
import 'package:ystfamily/src/features/notification/repository/notification_repository_impl.dart';

class ListNotificationNotifier extends AsyncNotifier<List<NotificationM>> {
  @override
  FutureOr<List<NotificationM>> build() {
    return ref.read(notificationRepositoryProvider).getNotificationList(
          limit: 10,
          offset: 0,
        );
  }
}

final notificationListProvider = AsyncNotifierProvider<ListNotificationNotifier, List<NotificationM>>(ListNotificationNotifier.new);
