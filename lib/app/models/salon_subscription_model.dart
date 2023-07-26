import 'package:beauty_clud_salon_owner/app/models/parents/model.dart';
import 'package:beauty_clud_salon_owner/app/models/payment_model.dart';
import 'package:beauty_clud_salon_owner/app/models/salon_model.dart';
import 'package:beauty_clud_salon_owner/app/models/subscription_package_model.dart';

class SalonSubscription extends Model {
  String id;
  Salon salon;
  SubscriptionPackage subscriptionPackage;
  DateTime startsAt;
  DateTime expiresAt;
  Payment payment;
  bool active;

  SalonSubscription({this.id, this.salon, this.subscriptionPackage, this.startsAt, this.expiresAt, this.payment, this.active});

  SalonSubscription.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    salon = objectFromJson(json, 'salon', (value) => Salon.fromJson(value));
    subscriptionPackage = objectFromJson(json, 'subscription_package', (value) => SubscriptionPackage.fromJson(value));
    startsAt = dateFromJson(json, 'starts_at', defaultValue: null);
    expiresAt = dateFromJson(json, 'expires_at', defaultValue: null);
    payment = objectFromJson(json, 'payment', (value) => Payment.fromJson(value));
    active = boolFromJson(json, 'active');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.salon != null && this.salon.hasData) {
      data['e_provider_id'] = this.salon.id;
    }
    if (this.subscriptionPackage != null && this.subscriptionPackage.hasData) {
      data['subscription_package_id'] = this.subscriptionPackage.id;
    }
    if (this.startsAt != null) {
      data['starts_at'] = startsAt.toUtc().toString();
    }
    if (this.expiresAt != null) {
      data['expires_at'] = expiresAt.toUtc().toString();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.active != null) {
      data['active'] = active;
    }
    return data;
  }
}
