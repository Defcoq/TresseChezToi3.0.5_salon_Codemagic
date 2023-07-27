import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/address_repository.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';

class SalonFormController extends GetxController {
  final salon = Salon().obs;
  final optionGroups = <OptionGroup>[].obs;
  final addresses = <Address>[].obs;
  final salons = <Salon>[].obs;
  GlobalKey<FormState> salonForm = new GlobalKey<FormState>();
  late EServiceRepository _eServiceRepository;
  late CategoryRepository _categoryRepository;
  late SalonRepository _salonRepository;
  late AddressRepository _addressRepository;

  SalonFormController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
    _salonRepository = new SalonRepository();
    _addressRepository= new AddressRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      salon.value = arguments['salon'] as Salon;
    }
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    await getSalon();
    await getAddresses();
    await getSalons();
    //await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name! + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalon() async {
    if (salon.value.hasData) {
      try {
        salon.value = await _salonRepository.get(salon.value.id!);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  Future getAddresses() async {
    try {
      print("inside edit controller 1");
      addresses.assignAll(await _addressRepository.getAll());
      print("after inside edit controller 1");
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSalons() async {
    try {
      salons.assignAll(await _salonRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<SelectDialogItem<Address>> getMultiSelectAddressItems() {
    return addresses.map((element) {
      return SelectDialogItem(element, element.address!);
    }).toList();
  }

  List<SelectDialogItem<Salon>> getSelectSalonsItems() {
    return salons.map((element) {
      return SelectDialogItem(element, element.name!);
    }).toList();
  }

  Future getOptionGroups() async {
    if (salon.value.hasData) {
      try {
        var _optionGroups = await _eServiceRepository.getOptionGroups(salon.value.id!);
        optionGroups.assignAll(_optionGroups);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !salon.value.hasData;
  }

  void createSalonForm({bool createOptions = false}) async {
    Get.focusScope!.unfocus();
    if (salonForm.currentState!.validate()) {
      try {
        salonForm.currentState!.save();
        var _eService = await _salonRepository.create(salon.value);
        if (createOptions)
          Get.offAndToNamed(Routes.OPTIONS_FORM, arguments: {'eService': _eService});
        else
          Get.offAndToNamed(Routes.SALON, arguments: {'salon': _eService, 'heroTag': 'e_service_create_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateSalonForm() async {
    Get.focusScope!.unfocus();
    if (salonForm.currentState!.validate()) {
      try {
        salonForm.currentState!.save();
        var _eService = await _salonRepository.update(salon.value);
        Get.offAndToNamed(Routes.SALON, arguments: {'salon': _eService, 'heroTag': 'e_service_update_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteSalon() async {
    try {
      await _salonRepository.delete(salon.value.id!);
      Get.offAndToNamed(Routes.SALONS);
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name! + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
