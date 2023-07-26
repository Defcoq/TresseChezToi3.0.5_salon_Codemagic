import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/notification_model.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../repositories/notification_repository.dart';
import '../../../repositories/subscription_repository.dart';
import '../../root/controllers/root_controller.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  NotificationRepository _notificationRepository;
  SubscriptionRepository _subscriptionRepository;

  NotificationsController() {
    _notificationRepository = new NotificationRepository();
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  void onInit() async {
    await refreshNotifications();
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    await getNotifications();
    Get.find<RootController>().getNotificationsCount();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications() async {
    try {

      List<Notification> _notifications = [];
      List<SalonSubscription> _subscriptions = [];
      _notifications = await _notificationRepository.getAll();
      _subscriptions = await _subscriptionRepository.getEProviderSubscriptions();

      bool providerHasValidSubscription=false;
      if(_notifications.isNotEmpty)
      {
        if(_subscriptions.isNotEmpty) {
          for (var sub in _subscriptions) {
            if (sub.active) {
              providerHasValidSubscription = true;
              break;
            }
          }
        }

        for(var notification in _notifications) {

          notification.iSProviderSubscriptionActive=providerHasValidSubscription;

        }

      }
      notifications.assignAll(await _notificationRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeNotification(Notification notification) async {
    try {
      await _notificationRepository.remove(notification);
      if (!notification.read) {
        --Get.find<RootController>().notificationsCount.value;
      }
      notifications.remove(notification);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future markAsReadNotification(Notification notification) async {
    try {
      if (!notification.read) {
        await _notificationRepository.markAsRead(notification);
        notification.read = true;
        --Get.find<RootController>().notificationsCount.value;
        notifications.refresh();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
