import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/salon_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class SalonsController extends GetxController {
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final salons = <Salon>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  SalonRepository _salonRepository;
  EServiceRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();

  SalonsController() {
    _salonRepository = new SalonRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadSalonsOfCategory(filter: selected.value);
      }
    });
    await refreshEServices();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    toggleSelected(selected.value);
    await loadSalonsOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.salons.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadSalonsOfCategory({CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Salon> _salons = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _salons = await _salonRepository.getAllWithPaging(page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _salons = await _salonRepository.getAllWithPaging(page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _salons = await _salonRepository.getAllWithPaging(page: this.page.value);
          break;
        case CategoryFilter.RATING:
          _salons = await _salonRepository.getAllWithPaging(page: this.page.value);
          break;
        case CategoryFilter.AVAILABILITY:
          _salons = await _salonRepository.getAllWithPaging(page: this.page.value);
          break;
        default:
          _salons = await _salonRepository.getAllWithPaging(page: this.page.value);
      }
      if (_salons.isNotEmpty) {
        this.salons.addAll(_salons);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void deleteEService(Salon salon) async {
    try {
      await _salonRepository.delete(salon.id);
      salons.remove(salon);
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.name + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
