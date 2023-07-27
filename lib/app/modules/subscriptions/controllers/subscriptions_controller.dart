import 'package:get/get.dart';

import '../../../../common/ui.dart';

import '../../../models/salon_subscription_model.dart';
import '../../../repositories/subscription_repository.dart';

class SubscriptionsController extends GetxController {
  final eProviderSubscriptions = <SalonSubscription>[].obs;
  late SubscriptionRepository _subscriptionRepository;

  SubscriptionsController() {
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshSubscriptions();
    super.onInit();
  }

  Future refreshSubscriptions({bool? showMessage}) async {
    await getSubscriptions();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of subscriptions refreshed successfully".tr));
    }
  }

  Future getSubscriptions() async {
    try {
      eProviderSubscriptions.clear();
      eProviderSubscriptions.assignAll(await _subscriptionRepository.getEProviderSubscriptions());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
