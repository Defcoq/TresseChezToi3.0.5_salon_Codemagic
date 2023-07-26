import 'package:get/get.dart';

import '../../../../common/ui.dart';

import '../../../models/salon_model.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../models/subscription_package_model.dart';
import '../../../repositories/salon_repository.dart';
import '../../../repositories/subscription_repository.dart';
import '../../global_widgets/select_dialog.dart';

class PackagesController extends GetxController {
  final subscriptionPackages = <SubscriptionPackage>[].obs;
  final eProviderSubscription = SalonSubscription().obs;
  final eProviders = <Salon>[].obs;
  SubscriptionRepository _subscriptionRepository;
  SalonRepository _eProviderRepository;

  PackagesController() {
    _subscriptionRepository = new SubscriptionRepository();
    _eProviderRepository = new SalonRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshSubscriptionPackages();
    super.onInit();
  }

  Future refreshSubscriptionPackages({bool showMessage}) async {
    await getEProviders();
    await getSubscriptionPackages();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of packages refreshed successfully".tr));
    }
  }

  Future getSubscriptionPackages() async {
    try {
      subscriptionPackages.clear();
      subscriptionPackages.assignAll(await _subscriptionRepository.getSubscriptionPackages());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviders() async {
    try {
      eProviders.clear();
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<Salon>> getSelectProvidersItems() {
    return eProviders.map((element) {
      return SelectDialogItem(element, element.name);
    }).toList();
  }
}
