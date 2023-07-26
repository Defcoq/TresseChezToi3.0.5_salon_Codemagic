import 'package:get/get.dart';

import '../models/salon_subscription_model.dart';
import '../models/subscription_package_model.dart';
import '../providers/laravel_provider.dart';

class SubscriptionRepository {
  LaravelApiClient _laravelApiClient;

  SubscriptionRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<SubscriptionPackage>> getSubscriptionPackages() {
    return _laravelApiClient.getSubscriptionPackages();
  }

  Future<SalonSubscription> cashEProviderSubscription(eProviderSubscription) {
    return _laravelApiClient.cashEProviderSubscription(eProviderSubscription);
  }

  Future<SalonSubscription> walletEProviderSubscription(eProviderSubscription, wallet) {
    return _laravelApiClient.walletEProviderSubscription(eProviderSubscription, wallet);
  }

  Future<List<SalonSubscription>> getEProviderSubscriptions() {
    return _laravelApiClient.getEProviderSubscriptions();
  }
}
