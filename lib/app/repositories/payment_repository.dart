import 'package:get/get.dart';

import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/salon_subscription_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import '../providers/laravel_provider.dart';

class PaymentRepository {
  late LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<Payment> update(Payment payment) {
    return _laravelApiClient.updatePayment(payment);
  }


  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) {
    return _laravelApiClient.getWalletTransactions(wallet);
  }

  Future<Wallet> createWallet(Wallet wallet) {
    return _laravelApiClient.createWallet(wallet);
  }

  Future<Wallet> updateWallet(Wallet wallet) {
    return _laravelApiClient.updateWallet(wallet);
  }

  Future<bool> deleteWallet(Wallet wallet) {
    return _laravelApiClient.deleteWallet(wallet);
  }


  String getPayPalUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getPayPalUrl(eProviderSubscription);
  }

  String getRazorPayUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getRazorPayUrl(eProviderSubscription);
  }

  String getStripeUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getStripeUrl(eProviderSubscription);
  }

  String getPayStackUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getPayStackUrl(eProviderSubscription);
  }

  String getPayMongoUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getPayMongoUrl(eProviderSubscription);
  }

  String getFlutterWaveUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getFlutterWaveUrl(eProviderSubscription);
  }

  String getKkiapayUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getKkiapayUrl(eProviderSubscription);
  }

  String getCinetpayUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getCinetpayUrl(eProviderSubscription);
  }

  String getWazapayUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getWazapayUrl(eProviderSubscription);
  }

  String getStripeFPXUrl(SalonSubscription eProviderSubscription) {
    return _laravelApiClient.getStripeFPXUrl(eProviderSubscription);
  }

  Future<List<PaymentMethod>> getMethods() {
    return _laravelApiClient.getPaymentMethods();
  }

}
