import 'package:get/get.dart';

import '../../common/helper.dart';
import '../models/global_model.dart';
import '../modules/root/controllers/country_selection_controller.dart';

/*class GlobalService extends GetxService {
  final global = Global().obs;

  Future<GlobalService> init() async {
    var response = await Helper.getJsonFile('config/global.json');
    global.value = Global.fromJson(response);
    return this;
  }

  String get baseUrl => global.value.laravelBaseUrl!;
}*/

class GlobalService extends GetxService {
  final global = Global().obs;
  final selectedClient = ''.obs; // Add a selectedClient variable to store the selected client
  GlobalService();

  Future<GlobalService> initDefault() async {
    var response = await Helper.getJsonFile('config/global.json');
    global.value = Global.fromJson(response);
    return this;
  }

  Future<GlobalService> init() async {
    var response = await Helper.getJsonFile('config/global.json');
    global.value = Global.fromJson(response);

    // Use the selected client from the CountrySelectionController
    // String selectedClient = countryController.selectedClient.value;
    // global.value.laravelBaseUrl = response[selectedClient];

    // Use the selected client to set the base URL
    //String selectedClient = this.selectedClient.value;
    //String selectedClient = Get.find<CountrySelectionController>().selectedClient.value;
    String selectedClient = Get.find<CountrySelectionController>().selectedClient.value;
    global.value.laravelBaseUrl = response[selectedClient];
    return this;
  }

  // Add a method to set the selected client
  void setSelectedClient(String client) {
    selectedClient.value = client;
    // Call the init method again to update the base URL with the selected client
    init();
  }

  String? get baseUrl {
    // Get the base URL for the selected client
    String? clientBaseUrl = global.value.laravelBaseUrl;
    return clientBaseUrl;
  }
}
