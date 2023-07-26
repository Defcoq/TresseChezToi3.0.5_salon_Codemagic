import 'package:get/get.dart';

import '../../search/controllers/search_controller.dart';
import '../controllers/salon_controller.dart';
import '../controllers/salon_form_controller.dart';
import '../controllers/salons_controller.dart';
import '../controllers/salons_options_form_controller.dart';


class SalonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalonsController>(
          () => SalonsController(),
    );
    Get.lazyPut<SalonController>(
          () => SalonController(),
    );
    Get.lazyPut<SalonFormController>(
          () => SalonFormController(),
    );
    Get.lazyPut<SalonsOptionsFormController>(
          () => SalonsOptionsFormController(),
    );
    Get.lazyPut<SearchController>(
          () => SearchController(),
    );
  }
}
