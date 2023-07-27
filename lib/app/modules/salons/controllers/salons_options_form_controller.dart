import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/availability_hour_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/salon_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/select_dialog.dart';

class SalonsOptionsFormController extends GetxController {
  final salon = Salon().obs;
  final availability = AvailabilityHour().obs;
  final availabilities = <AvailabilityHour>[].obs;
  final days = <String>[].obs;
  GlobalKey<FormState> optionForm = new GlobalKey<FormState>();
  late SalonRepository _salonRepository;


  SalonsOptionsFormController() {
    _salonRepository = new SalonRepository();

  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    _initSalon(arguments);
    _initAvailability(arguments: arguments);
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshOptions();
    super.onReady();
  }

  void _initSalon(Map<String, dynamic> arguments) {
    if (arguments != null) {
      salon.value = arguments['salon'] as Salon;
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

  void _initAvailability({Map<String, dynamic>? arguments}) {
    if (arguments != null) {
      availability.value = (arguments['availability'] as AvailabilityHour) ?? availability();
    } else {
      availability.value = new AvailabilityHour();
    }

  }

  void _initOptionGroup() {
    availability.update((val) {
      val?.id = availabilities
          .firstWhere(
            (element) => element.id == availability.value.id,
            orElse: () => availabilities.isNotEmpty ? availabilities.first : new AvailabilityHour(),
          )
          .id;
    });
  }

  Future refreshOptions({bool showMessage = false}) async {
    await getSalon();
    //await getOptionGroups();
    getDays();
    _initOptionGroup();
  }

  List<SelectDialogItem<String>> getSelectDaysItems() {
    return days.map((element) {
      return SelectDialogItem(element, element);
    }).toList();
  }

  Future getDays() async {
    try {
      // var days = String[];
      days.clear();
      days.add("monday");
      days.add("tuesday");
      days.add("wednesday");
      days.add("thursday");
      days.add("friday");
      days.add("saturday");
      days.add("sunday");

      //availabilities.assignAll(_optionGroups);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !availability.value.hasData;
  }

  void createOptionForm({bool addOther = false}) async {
    Get.focusScope!.unfocus();
    if (optionForm.currentState!.validate()) {
      try {
        optionForm.currentState!.save();
        await _salonRepository.createAvailabilityHour(availability.value);
        if (addOther) {
          _resetOptionForm();
        } else {
          await Get.offAndToNamed(Routes.SALON, arguments: {'salon': salon.value, 'heroTag': 'option_create_form'});
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void _resetOptionForm() {
    _initAvailability();

    _initOptionGroup();
    Get.find<ImageFieldController>(tag: optionForm.hashCode.toString()).reset();
    optionForm.currentState!.reset();
  }

  void updateOptionForm() async {
    Get.focusScope!.unfocus();
    if (optionForm.currentState!.validate()) {
      try {
        optionForm.currentState!.save();
        await _salonRepository.updateAvailabilityHour(availability.value);
        Get.offAndToNamed(Routes.SALON, arguments: {'salon': salon.value, 'heroTag': 'option_update_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteOption(AvailabilityHour availabilityHour) async {
    try {
      await _salonRepository.deleteAvailabilityHour(availability.value.id!);
      Get.offAndToNamed(Routes.SALON, arguments: {'salon': salon.value, 'heroTag': 'option_remove_form'});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
