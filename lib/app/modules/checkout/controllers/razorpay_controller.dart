import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';

class RazorPayController extends GetxController {
  WebViewController? webView;
  late PaymentRepository _paymentRepository;
  final url = "".obs;
  final progress = 0.0.obs;
  final eProviderSubscription = new SalonSubscription().obs;

  RazorPayController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() {
    eProviderSubscription.value = Get.arguments['eProviderSubscription'] as SalonSubscription;
    getUrl();
    super.onInit();
  }

  void getUrl() {
    url.value = _paymentRepository.getRazorPayUrl(eProviderSubscription.value);
    print(url.value);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}subscription/payments/razorpay";
    if (url == _doneUrl) {
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
