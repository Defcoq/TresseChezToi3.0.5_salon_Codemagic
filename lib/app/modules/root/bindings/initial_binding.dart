import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../../services/global_service.dart';
import '../controllers/country_selection_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize your services here
    Get.put<GlobalService>(GlobalService());
    Get.put<CountrySelectionController>(CountrySelectionController());
  }
}
