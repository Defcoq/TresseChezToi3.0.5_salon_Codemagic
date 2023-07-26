import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';

import '../../common/uuid.dart';
import '../models/address_model.dart';
import '../models/availability_hour_model.dart';
import '../models/award_model.dart';
import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../models/category_model.dart';
import '../models/custom_page_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../models/notification_model.dart';
import '../models/option_group_model.dart';
import '../models/option_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_model.dart';
import '../models/review_model.dart';
import '../models/salon_model.dart';
import '../models/salon_subscription_model.dart';
import '../models/setting_model.dart';
import '../models/statistic.dart';
import '../models/subscription_package_model.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';
import 'api_provider.dart';
import 'package:intl/intl.dart' show DateFormat;

class LaravelApiClient extends GetxService with ApiClient {
  dio.Dio _httpClient;
  dio.Options _optionsNetwork;
  dio.Options _optionsCache;

  LaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl;
    _httpClient = new dio.Dio();
  }

  Future<LaravelApiClient> init() async {
    if (foundation.kIsWeb || foundation.kDebugMode) {
      _optionsNetwork = dio.Options();
      _optionsCache = dio.Options();
    } else {
      _optionsNetwork = buildCacheOptions(Duration(days: 3), forceRefresh: true);
      _optionsCache = buildCacheOptions(Duration(minutes: 10), forceRefresh: false);
      _httpClient.interceptors.add(DioCacheManager(CacheConfig(baseUrl: getApiBaseUrl(""))).interceptor);
    }
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = dio.Options();
    }
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Future<User> getUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/user").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("salon_owner/login");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> register(User user) async {
    Uri _uri = getApiBaseUri("salon_owner/register");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendResetLinkEmail(User user) async {
    Uri _uri = getApiBaseUri("salon_owner/send_reset_link_email");
    Get.log(_uri.toString());
    // to remove other attributes from the user object
    user = new User(email: user.email);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<User> updateUser(User user) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateUser() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/users/${user.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      response.data['data']['auth'] = true;
      return User.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Statistic>> getHomeStatistics() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getHomeStatistics() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/dashboard").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Statistic>((obj) => Statistic.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAddresses() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'search': "user_id:${authService.user.value.id}",
      'searchFields': 'user_id:=',
      'orderBy': 'id',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> searchEServices(String keywords, List<String> categories, int page) async {
    // TODO Pagination
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'search': 'categories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'categories.id:in;name:like',
      'searchJoin': 'and',
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> getEService(String id) async {
    var _queryParameters = {
      'with': 'salon;categories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("e_services/$id").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> createEService(EService eService) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(eService.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return EService.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<EService> updateEService(EService eService) async {
    if (!authService.isAuth || !eService.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/e_services/${eService.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eService.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteEService(String eServiceId) async {
    if (!authService.isAuth || eServiceId == null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteEService(String eServiceId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${eServiceId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<EService> createSalon(Salon salon) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createSalon(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    try {
      var response = await _httpClient.postUri(
        _uri,
        data: json.encode(salon.toJson()),
        options: _optionsNetwork,
      );
      if (response.data['success'] == true) {
        return EService.fromJson(response.data['data']);
      } else {
        throw new Exception(response.data['message']);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<EService> updateSalon(Salon salon) async {
    if (!authService.isAuth || !salon.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateEService(EService eService) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/e_services/${salon.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(salon.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return EService.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteSalon(String salonId) async {
    if (!authService.isAuth || salonId == null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteSalon(String eServiceId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("e_services/${salonId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> createOption(Option option) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options").replace(queryParameters: _queryParameters);
    print(option.toJson());
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<AvailabilityHour> createAvailabilityHour(AvailabilityHour availabilityHour) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("availability_hours").replace(queryParameters: _queryParameters);
    print(availabilityHour.toJson());
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(availabilityHour.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return AvailabilityHour.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Option> updateOption(Option option) async {
    if (!authService.isAuth || !option.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${option.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print(option.toJson());
    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(option.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return Option.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<AvailabilityHour> updateAvailabilityHour(AvailabilityHour availabilityHour) async {
    if (!authService.isAuth || !availabilityHour.hasData) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateOption(Option option) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("availability_hours/${availabilityHour.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print(availabilityHour.toJson());
    var response = await _httpClient.patchUri(
      _uri,
      data: json.encode(availabilityHour.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return AvailabilityHour.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<bool> deleteOption(String optionId) async {
    if (!authService.isAuth || optionId == null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteOption(String optionId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("options/${optionId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<bool> deleteAvailabilityHour(String availabilityId) async {
    if (!authService.isAuth || availabilityId == null) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteOption(String optionId) ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("availability_hours/${availabilityId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(
      _uri,
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Salon> getSalon(String salonId) async {
    const _queryParameters = {
      'with': 'salonLevel;availabilityHours;users;taxes;address',
    };
    Uri _uri = getApiBaseUri("salons/$salonId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Salon.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getSalons() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getSalons() ]");
    }
    /*var _queryParameters = {
      'only': 'id;name',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };*/
    var _queryParameters = {
      'with': 'salonLevel;availabilityHours;users;taxes;address',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    print("========== getSalons check user salon data Before ===================");
    Uri _uri = getApiBaseUri("salon_owner/salons").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print("========== getSalons check user salon data After ===================");
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Salon>((obj) => Salon.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Salon>> getSalonsWithPaging(int page) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getSalons() ]");
    }

    var _queryParameters = {
      'with': 'salonLevel;availabilityHours;users;taxes;address',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    print("========== getSalons check user salon data Before ===================");
    Uri _uri = getApiBaseUri("salon_owner/salons").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print("========== getSalons check user salon data After ===================");
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Salon>((obj) => Salon.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getSalonReviews() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getSalonReviews() ]");
    }
    var _queryParameters = {
      'with': 'booking;booking.user',
      'only': 'id;review;rate;created_at;booking',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '10',
      'api_token': authService.apiToken,
    };
    print(_queryParameters);
    Uri _uri = getApiBaseUri("salon_owner/salon_reviews").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Review> getSalonReview(String reviewId) async {
    var _queryParameters = {
      'with': 'eService;user',
      'only': 'id;review;rate;user;eService',
    };
    Uri _uri = getApiBaseUri("e_service_reviews/$reviewId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return Review.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Award>> getSalonAwards(String salonId) async {
    var _queryParameters = {
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("awards").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Award>((obj) => Award.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Experience>> getSalonExperiences(String salonId) async {
    var _queryParameters = {
      'search': 'salon_id:$salonId',
      'searchFields': 'salon_id:=',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("experiences").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Experience>((obj) => Experience.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonFeaturedEServices(int page) async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonPopularEServices(int page) async {
    // TODO popular eServices
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonAvailableEServices(int page) async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories',
      'available_salon': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    Uri _uri = getApiBaseUri("salon_owner/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonMostRatedEServices(int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'salon;salon.address;categories',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken
    };
    Uri _uri = getApiBaseUri("salon_owner/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getSalonEmployees(String salonId) async {
    var _queryParameters = {'with': 'users', 'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token'};
    Uri _uri = getApiBaseUri("salons/$salonId").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<EService>> getSalonEServices(int page) async {
    var _queryParameters = {
      'with': 'salon;salon.address;categories;media',
      'limit': '4',
      'offset': ((page - 1) * 4).toString(),
      'api_token': authService.apiToken,
    };
    print("========== getSalonEServices check user salon data Before ===================");
    Uri _uri = getApiBaseUri("salon_owner/e_services").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    print("========== getSalonEServices check user salon data After ===================");



    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<EService>((obj) => EService.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var _queryParameters = {
      'with': 'booking;booking.user',
      'only': 'created_at;review;rate;booking',
      'search': "booking.e_services.id:$eServiceId",
      'orderBy': 'created_at',
      'sortBy': 'desc',
      'limit': '10',
    };
    Uri _uri = getApiBaseUri("salon_reviews").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Review>((obj) => Review.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getEServiceOptionGroups(String eServiceId) async {
    var _queryParameters = {
      'with': 'options;options.media',
      'only': 'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id;options.media',
      'search': "options.e_service_id:$eServiceId",
      'searchFields': 'options.e_service_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getOptionGroups() async {
    var _queryParameters = {
      'with': 'options',
      'only': 'id;name;allow_multiple;options.id;options.name;options.description;options.price;options.option_group_id;options.e_service_id',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("option_groups").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Address>> getAllAddress() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getAddresses() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orderBy': 'id',
      'sortedBy': 'desc',
    };
    print("biefore calinggggggggggggggggggggggggggggggggg");
    Uri _uri = getApiBaseUri("addresses").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Address>((obj) => Address.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<AvailabilityHour>> getAvailabilityHours(String salonId) async {
    var _queryParameters = {
      'date': DateFormat('y-MM-dd').format(DateTime.now()),
      'employee_id': '0',
    };
    Uri _uri = getApiBaseUri("availability_hours/$salonId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<AvailabilityHour>((obj) => AvailabilityHour.fromJson(obj)).toList();
      //return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Booking>> getBookings(String statusId, int page) async {
    var _queryParameters = {
      'with': 'bookingStatus:id,status,order;payment:id,payment_status_id;user:id,name;employee:id,name;payment.paymentStatus:id,status',
      'api_token': authService.apiToken,
      'search': 'booking_status_id:${statusId}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("bookings").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Booking>((obj) => Booking.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<BookingStatus>> getBookingStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("booking_statuses").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<BookingStatus>((obj) => BookingStatus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> getBooking(String bookingId) async {
    var _queryParameters = {
      'with': 'bookingStatus;user;employee;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("bookings/${bookingId}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Booking> updateBooking(Booking booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateBooking() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/bookings/${booking.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Booking.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> updatePayment(Payment payment) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updatePayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/payments/${payment.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.putUri(_uri, data: payment.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Notification>> getNotifications() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getNotifications() ]");
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'limit': '50',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
   // print("Json Result return From Server before call =>");
   // print(response.data.toString());
    if (response.data['success'] == true) {
      print("Json Result return From Server =>");

      print(response.data['data'].toString());
     // var data = response.data['data'].map<Notification>((obj) => Notification.fromJson(obj)).toList();
     // print("");
     // print(data);
      return response.data['data'].map<Notification>((obj) => Notification.fromJson(obj)).toList();
    } else {
      print("Json Result return From Server error =>");
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> markAsReadNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ markAsReadNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("salon_owner/notifications/${notification.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: notification.markReadMap(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ sendNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    var data = {
      'users': users.map((e) => e.id).toList(),
      'from': from.id,
      'type': type,
      'text': text,
      'id': id,
    };
    Uri _uri = getApiBaseUri("notifications").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    Get.log(data.toString());
    var response = await _httpClient.postUri(_uri, data: data, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Notification> removeNotification(Notification notification) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeNotification() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/${notification.id}").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Notification.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getNotificationsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'search': 'notifiable_id:${authService.user.value.id}',
      'searchFields': 'notifiable_id:=',
      'searchJoin': 'and',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("notifications/count").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      print("Count "+ response.data['data'].toString());
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<FaqCategory>> getFaqCategories() async {
    var _queryParameters = {
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("faq_categories").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<FaqCategory>((obj) => FaqCategory.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Faq>> getFaqs(String categoryId) async {
    var _queryParameters = {
      'search': 'faq_category_id:${categoryId}',
      'searchFields': 'faq_category_id:=',
      'searchJoin': 'and',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("faqs").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Faq>((obj) => Faq.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Setting> getSettings() async {
    Uri _uri = getApiBaseUri("salon_owner/settings");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Setting.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<CustomPage>> getCustomPages() async {
    var _queryParameters = {
      'only': 'id;title',
      'search': 'published:1',
      'orderBy': 'created_at',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("custom_pages").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<CustomPage>((obj) => CustomPage.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<CustomPage> getCustomPageById(String id) async {
    Uri _uri = getApiBaseUri("custom_pages/$id");
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return CustomPage.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<String> uploadImage(File file, String field) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ uploadImage() ]");
    }
    String fileName = file.path.split('/').last;
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/store").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    dio.FormData formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: fileName),
      "uuid": Uuid().generateV4(),
      "field": field,
    });
    var response = await _httpClient.postUri(_uri, data: formData);
    print(response.data);
    if (response.data['data'] != false) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteUploaded(String uuid) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuid});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteAllUploaded(List<String> uuids) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteUploaded() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("uploads/clear").replace(queryParameters: _queryParameters);
    printUri(StackTrace.current, _uri);
    var response = await _httpClient.postUri(_uri, data: {'uuid': uuids});
    print(response.data);
    if (response.data['data'] != false) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<List<Wallet>> getWallets() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getWallets() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Wallet>((obj) => Wallet.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> createWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Wallet> updateWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.putUri(_uri, data: _wallet.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Wallet.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> deleteWallet(Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ deleteWallet() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.deleteUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<WalletTransaction>> getWalletTransactions(Wallet wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getWalletTransactions() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'with': 'user',
      'search': 'wallet_id:${wallet.id}',
      'searchFields': 'wallet_id:=',
    };
    Uri _uri = getApiBaseUri("wallet_transactions").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.getUri(_uri, options: _optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<WalletTransaction>((obj) => WalletTransaction.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createPayment(Booking _booking) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/cash").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Payment> createWalletPayment(Booking _booking, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payments/wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(_uri, data: _booking.toJson(), options: _optionsNetwork);
    if (response.data['success'] == true) {
      return Payment.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  String getPayPalUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paypal/express-checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getRazorPayUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/razorpay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/stripe/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayStackUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paystack/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getPayMongoUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/paymongo/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getFlutterWaveUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/flutterwave/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getKkiapayUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/kkiapay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }


  String getCinetpayUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/cinetpay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }


  String getWazapayUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/wazapay/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  String getStripeFPXUrl(SalonSubscription eProviderSubscription) {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'subscription_package_id': eProviderSubscription.subscriptionPackage.id,
      'e_provider_id': eProviderSubscription.salon.id,
    };
    Uri _uri = getBaseUri("subscription/payments/stripe-fpx/checkout").replace(queryParameters: _queryParameters);
    return _uri.toString();
  }

  Future<List<SubscriptionPackage>> getSubscriptionPackages() async {
    var _queryParameters = {
      'orderBy': 'duration_in_days',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("subscription/subscription_packages").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<SubscriptionPackage>((obj) => SubscriptionPackage.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }


  Future<SalonSubscription> cashEProviderSubscription(SalonSubscription eProviderSubscription) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("subscription/e_provider_subscriptions/cash").replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eProviderSubscription.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return SalonSubscription.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<SalonSubscription> walletEProviderSubscription(SalonSubscription eProviderSubscription, Wallet _wallet) async {
    var _queryParameters = {
      'api_token': authService.apiToken,
      'wallet_id': _wallet.id,
    };
    Uri _uri = getApiBaseUri("subscription/e_provider_subscriptions/wallet/${_wallet.id}").replace(queryParameters: _queryParameters);
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(eProviderSubscription.toJson()),
      options: _optionsNetwork,
    );
    if (response.data['success'] == true) {
      return SalonSubscription.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<SalonSubscription>> getEProviderSubscriptions() async {
    var _queryParameters = {
      'with': 'salon;subscriptionPackage;payment;payment.paymentMethod',
      'orderBy': 'updated_at',
      'sortedBy': 'desc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("subscription/e_provider_subscriptions").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<SalonSubscription>((obj) => SalonSubscription.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    var _queryParameters = {
      'with': 'media',
      'search': 'enabled:1',
      'searchFields': 'enabled:=',
      'orderBy': 'order',
      'sortBy': 'asc',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods").replace(queryParameters: _queryParameters);

    var response = await _httpClient.getUri(_uri, options: _optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

}
