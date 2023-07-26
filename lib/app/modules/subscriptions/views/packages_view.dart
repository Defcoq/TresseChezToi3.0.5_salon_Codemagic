import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/salon_model.dart';
import '../../../models/salon_subscription_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/select_dialog.dart';
import '../controllers/packages_controller.dart';
import '../widgets/package_card_widget.dart';
import '../widgets/subscriptions_list_loader_widget.dart';

class PackagesView extends GetView<PackagesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Get.theme.hintColor),
        title: Text(
          "Subscription Packages".tr,
          style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3, color: Get.theme.hintColor)),
        ),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.refreshSubscriptionPackages(
            showMessage: true,
          );
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: ListView(
          primary: true,
          shrinkWrap: false,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: <Widget>[
            Text("Service Provider".tr, style: Get.textTheme.headline5),
            Text("Select the service provider".tr, style: Get.textTheme.caption).paddingOnly(top: 5),
            Obx(() {
              if (controller.eProviders.length > 1)
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                      ],
                      border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Providers".tr,
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              final selectedValue = await showDialog<Salon>(
                                context: context,
                                builder: (BuildContext context) {
                                  return SelectDialog(
                                    title: "Select Provider".tr,
                                    submitText: "Submit".tr,
                                    cancelText: "Cancel".tr,
                                    items: controller.getSelectProvidersItems(),
                                    initialSelectedValue: controller.eProviders.firstWhere(
                                      (element) => element.id == controller.eProviderSubscription.value.salon?.id,
                                      orElse: () => new Salon(),
                                    ),
                                  );
                                },
                              );
                              controller.eProviderSubscription.update((val) {
                                val.salon = selectedValue;
                              });
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                            child: Text("Select".tr, style: Get.textTheme.subtitle1),
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                          ),
                        ],
                      ),
                      Obx(() {
                        if (controller.eProviderSubscription.value?.salon == null) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Select providers".tr,
                              style: Get.textTheme.caption,
                            ),
                          );
                        } else {
                          return buildProvider(controller.eProviderSubscription.value);
                        }
                      })
                    ],
                  ),
                );
              else if (controller.eProviders.length == 1) {
                controller.eProviderSubscription.value.salon = controller.eProviders.first;
                return SizedBox();
              } else {
                return SubscriptionsListLoaderWidget(count: 1, itemHeight: 130).marginOnly(bottom: 20);
              }
            }),
            Text("Subscription Packages".tr, style: Get.textTheme.headline5),
            Text("Choose one of our packages for subscription".tr, style: Get.textTheme.caption).paddingOnly(top: 5, bottom: 10),
            Obx(() {
              if (controller.subscriptionPackages.isEmpty) return SubscriptionsListLoaderWidget(count: 3, itemHeight: 210);
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: controller.subscriptionPackages.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return PackageCardWidget(
                    subscriptionPackage: controller.subscriptionPackages.elementAt(index),
                    onTap: (subscriptionPackage) async {
                      if (controller.eProviderSubscription.value.salon == null) {
                        Get.showSnackbar(Ui.defaultSnackBar(message: "Please Select a Service Provider!".tr));
                      } else {
                        controller.eProviderSubscription.update((val) {
                          val.subscriptionPackage = subscriptionPackage;
                        });
                        print(controller.eProviderSubscription.value);
                        await Get.offAndToNamed(Routes.CHECKOUT, arguments: controller.eProviderSubscription.value);
                      }
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildProvider(SalonSubscription _eProviderSubscription) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_eProviderSubscription.salon?.name ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
