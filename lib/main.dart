/*
 * File name: main.dart
 * Last modified: 2022.02.17 at 16:26:56
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/root/bindings/initial_binding.dart';
import 'app/modules/root/controllers/country_selection_controller.dart';
import 'app/modules/root/views/country_selection_view.dart';
import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
import 'common/country_selection_setup_helper.dart';
import 'package:upgrader/upgrader.dart';

Future<void> initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  await Get.putAsync(() => TranslationService().init());
  await Get.putAsync(() => CountrySelectionController().init());
  await Get.putAsync(() => GlobalService().initDefault());
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();


  runApp(
    GetMaterialApp(
      //title: Get.find<SettingsService>().setting.value.salonAppName,
      title: "Tresse Chez Toi".tr,
      //initialRoute: Theme1AppPages.INITIAL,
      home: UpgradeAlert(
          child: CountrySelectionView()),
      onReady: () async {
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      getPages: Theme1AppPages.routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: Get.find<SettingsService>().getLocale(),
      fallbackLocale: Get.find<TranslationService>().fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  );

 /* await initServices();
  runApp(
    GetMaterialApp(
      //title: Get.find<SettingsService>().setting.value.appName,
      title: "Tresse Chez Toi".tr,
      initialBinding: InitialBinding(),
      home: CountrySelectionView(),
      onReady: () async {
        await Firebase.initializeApp();
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      //initialRoute: Theme1AppPages.INITIAL,

      getPages: Theme1AppPages.routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: CountrySelectionSetupHelper.getLocale(),
      fallbackLocale: Get.find<TranslationService>().fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: CountrySelectionSetupHelper.getThemeMode(),
      theme: CountrySelectionSetupHelper.getLightTheme(),
      darkTheme: CountrySelectionSetupHelper.getDarkTheme(),
    ),
  );*/
  /*runApp(
    GetMaterialApp(
      //title: Get.find<SettingsService>().setting.value.appName,
      title: "Tresse Chez Toi".tr,
      initialBinding: InitialBinding(),
      home: CountrySelectionView(),
      onReady: () async {
        await Firebase.initializeApp();
        await Get.putAsync(() => FireBaseMessagingService().init());
      },
      //initialRoute: Theme1AppPages.INITIAL,

      getPages: Theme1AppPages.routes,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: CountrySelectionSetupHelper.supportedLocales(),
      translationsKeys: CountrySelectionSetupHelper.translations,
      locale: CountrySelectionSetupHelper.getLocale(),
      fallbackLocale: CountrySelectionSetupHelper.fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: CountrySelectionSetupHelper.getThemeMode(),
      theme: CountrySelectionSetupHelper.getLightTheme(),
      darkTheme: CountrySelectionSetupHelper.getDarkTheme(),
    ),
  );*/
}
