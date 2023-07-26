import 'package:get/get.dart';

import '../controllers/packages_controller.dart';
import '../controllers/subscriptions_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackagesController>(
      () => PackagesController(),
    );
    Get.lazyPut<SubscriptionsController>(
      () => SubscriptionsController(),
    );
  }
}
