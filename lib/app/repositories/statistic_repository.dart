import 'package:get/get.dart';

import '../models/statistic.dart';
import '../providers/laravel_provider.dart';

class StatisticRepository {
  late LaravelApiClient _laravelApiClient;

  StatisticRepository() {
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Statistic>> getHomeStatistics() {
    return _laravelApiClient.getHomeStatistics();
  }
}
