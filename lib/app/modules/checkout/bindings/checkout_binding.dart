import 'package:get/get.dart';

import '../controllers/KkiapayController.dart';
import '../controllers/cash_controller.dart';
import '../controllers/checkout_controller.dart';
import '../controllers/cinetpay_controller.dart';
import '../controllers/flutterwave_controller.dart';
import '../controllers/paymongo_controller.dart';
import '../controllers/paypal_controller.dart';
import '../controllers/paystack_controller.dart';
import '../controllers/razorpay_controller.dart';
import '../controllers/stripe_controller.dart';
import '../controllers/stripe_fpx_controller.dart';
import '../controllers/wallet_controller.dart';
import '../controllers/wazapay_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
    Get.lazyPut<PayPalController>(
      () => PayPalController(),
    );
    Get.lazyPut<RazorPayController>(
      () => RazorPayController(),
    );
    Get.lazyPut<PayStackController>(
      () => PayStackController(),
    );
    Get.lazyPut<PayMongoController>(
      () => PayMongoController(),
    );
    Get.lazyPut<FlutterWaveController>(
      () => FlutterWaveController(),
    );

    Get.lazyPut<KkiapayController>(
          () => KkiapayController(),
    );

    Get.lazyPut<CinetPayController>(
          () => CinetPayController(),
    );

    Get.lazyPut<WazaPayController>(
          () => WazaPayController(),
    );

    Get.lazyPut<StripeController>(
      () => StripeController(),
    );
    Get.lazyPut<StripeFPXController>(
      () => StripeFPXController(),
    );
    Get.lazyPut<CashController>(
      () => CashController(),
    );
    Get.lazyPut<WalletController>(
      () => WalletController(),
    );
  }
}