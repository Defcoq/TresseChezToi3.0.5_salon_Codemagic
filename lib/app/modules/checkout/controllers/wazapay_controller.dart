import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';

class WazaPayController extends GetxController {
  WebViewController webView;
  PaymentRepository _paymentRepository;
  final url = "".obs;
  final progress = 0.0.obs;
  final salonSubscription = new SalonSubscription().obs;

  WazaPayController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    salonSubscription.value = Get.arguments['eProviderSubscription'] as SalonSubscription;
    getUrl();
    super.onInit();
  }

  void getUrl() {
    url.value = _paymentRepository.getWazapayUrl(salonSubscription.value);
    print(url.value);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}subscription/payments/wazapay";
    if (url == _doneUrl) {
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
