import 'dart:convert';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/subscription_repository.dart';

class WalletController extends GetxController {
  final eProviderSubscription = new SalonSubscription().obs;
  final wallet = new Wallet().obs;

  SubscriptionRepository _subscriptionRepository;

  WalletController() {
    _subscriptionRepository = new SubscriptionRepository();
  }

  @override
  void onInit() {
    eProviderSubscription.value = Get.arguments['eProviderSubscription'] as SalonSubscription;
    wallet.value = Get.arguments['wallet'] as Wallet;
    paySubscription();
    super.onInit();
  }

  Future paySubscription() async {
    try {
      print("JP============> ${jsonEncode(eProviderSubscription.value)}");
      eProviderSubscription.value = await _subscriptionRepository.walletEProviderSubscription(eProviderSubscription.value, wallet.value);
    } catch (e) {
      print("errorrrrrrrrr=> ");
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
