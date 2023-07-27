import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../repositories/subscription_repository.dart';

class CashController extends GetxController {
  final eProviderSubscription = new SalonSubscription().obs;

  late SubscriptionRepository _subscriptionRepository;

  CashController() {
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  void onInit() {
    eProviderSubscription.value = Get.arguments['eProviderSubscription'] as SalonSubscription;
    paySubscription();
    super.onInit();
  }

  Future paySubscription() async {
    try {
      eProviderSubscription.value = await _subscriptionRepository.cashEProviderSubscription(eProviderSubscription.value);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  bool isLoading() {
    if (eProviderSubscription.value != null && !eProviderSubscription.value.hasData) {
      return true;
    }
    return false;
  }

  bool isDone() {
    if (eProviderSubscription.value != null && eProviderSubscription.value.hasData) {
      return true;
    }
    return false;
  }

  bool isFailed() {
    if (eProviderSubscription.value == null) {
      return true;
    }
    return false;
  }
}
