import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/category_model.dart';
import '../providers/laravel_provider.dart';

class AddressRepository {
  LaravelApiClient _laravelApiClient;

  AddressRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Address>> getAll() {
    print("inside edit controller 2");
    return _laravelApiClient.getAllAddress();
  }


}
