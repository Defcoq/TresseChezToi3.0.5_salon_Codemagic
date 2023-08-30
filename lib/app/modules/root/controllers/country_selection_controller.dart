

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

import '../../../providers/firebase_provider.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_service.dart';
import '../../../services/settings_service.dart';
import '../../../services/translation_service.dart';

class CountrySelectionController extends GetxController {

  CountrySelectionController() {
    //selectedClient.value = 'laravel_base_url_rekou'; // Set a default value here
    // selectedClient.value = 'laravel_base_url_rekou';
  }
  final Map<String, String> clients = {
    'laravel_base_url_europa': 'TresseChezToi Europe',
    'laravel_base_url_usa': 'TresseChezToi Usa',
    'laravel_base_url_canada': 'TresseChezToi Canada',
    'laravel_base_url_domtom': 'TresseChezToi Dom-Tom',
    'laravel_base_url_cameroun': 'TresseChezToi Cameroun',
  };
  //var selectedClient = RxString('');
  var selectedClient = ''.obs;
  var isCountrySelected = false.obs;

  Future<CountrySelectionController> init() async {
    return this;
  }


  Future<void> setSelectedClient(String client) async {
    selectedClient.value = client;
    Get.find<GlobalService>().setSelectedClient(client);
    isCountrySelected.value = true;
    update();
    // update(); // Update the UI to reflect the selected client
  }
  /*
  Future<void> setSelectedClient(String client) async {
    selectedClient.value = client;
   Get.find<GlobalService>().setSelectedClient(client);
   // await initServices();
    isCountrySelected.value = true;
   // Get.toNamed(Routes.ROOT);
  }*/

  String getDescription(String client) {
    return clients[client] ?? '';
  }

  /*Future<void> initServices() async {
    Get.log('starting services ...');
    await GetStorage.init();
    await Get.putAsync(() => GlobalService().init());
    await Firebase.initializeApp();
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => LaravelApiClient().init());
    await Get.putAsync(() => FirebaseProvider().init());
    await Get.putAsync(() => SettingsService().init());
    await Get.putAsync(() => TranslationService().init());
    Get.log('All services started...');
  }*/

  Future<void>  initServices() async {
    Get.log('starting services ...');
    await GetStorage.init();
    await Get.putAsync(() => TranslationService().init());
    await Get.putAsync(() => GlobalService().init());
    await Firebase.initializeApp();
    await Get.putAsync(() => AuthService().init());
    await Get.putAsync(() => LaravelApiClient().init());
    await Get.putAsync(() => FirebaseProvider().init());
    await Get.putAsync(() => SettingsService().init());
    Get.log('All services started...');
  }
}