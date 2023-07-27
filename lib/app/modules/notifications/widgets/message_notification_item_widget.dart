import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/message_model.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../../global_widgets/confirm_dialog.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class MessageNotificationItemWidget extends GetView<NotificationsController> {
  MessageNotificationItemWidget({Key? key, this.notification}) : super(key: key);
  final model.Notification? notification;

  @override
  Widget build(BuildContext context) {
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        controller.removeNotification(notification);
      },
      icon: Icon(
        Icons.chat_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {

        if(!notification.iSProviderSubscriptionActive!)
        {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return ConfirmDialog(
                title: "Confirm Subscription".tr,
                content: "This action required a valid subscription, do you need to go to payment gateway?".tr,
                submitText: "Confirm".tr,
                cancelText: "Cancel".tr,
              );
            },
          );
          if (confirm!) {
            Get.showSnackbar(Ui.SuccessSnackBar(message: "You are redirecting to payment gateway".tr));

            Get.toNamed(Routes.PACKAGES);
          }
          else
          {
            Get.find<RootController>().changePage(0);
          }
        }
        else {
          Get.toNamed(Routes.CHAT, arguments: new Message(
              [], id: notification.data!['message_id'].toString()));
          await controller.markAsReadNotification(notification);
        }
      },
    );
  }
}
