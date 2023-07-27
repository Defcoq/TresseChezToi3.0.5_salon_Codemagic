import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/availability_hour_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/review_model.dart';
import '../../../models/salon_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/salon_repository.dart';

class SalonController extends GetxController {
  final salon = Salon().obs;
  final reviews = <Review>[].obs;
  final availabilityHours = <AvailabilityHour>[].obs;
  final currentSlide = 0.obs;
  final heroTag = ''.obs;
  late SalonRepository _salonRepository;

  SalonController() {
    _salonRepository = new SalonRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    salon.value = arguments['salon'] as Salon;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    await getSalon();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: salon.value.name! + " " + "page refreshed successfully".tr));
    }
  }

  Future getSalon() async {
    try {
      salon.value = await _salonRepository.get(salon.value.id!);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void SorteAvailabilityHour()
  {
    this.salon.value.availabilityHours?.map((e) => {

      if(e.day!.toLowerCase() == "monday")
        {
          e.sortOrder =1
        }
      else if(e.day!.toLowerCase() == "tuesday")
        {
          e.sortOrder =2
        }
      else if(e.day!.toLowerCase() == "wednesday")
          {
            e.sortOrder =3
          }
        else if(e.day!.toLowerCase() == "thursday")
            {
              e.sortOrder =4
            }
          else if(e.day!.toLowerCase() == "friday")
              {
                e.sortOrder =5
              }
            else if(e.day!.toLowerCase() == "saturday")
                {
                  e.sortOrder =6
                }

              else if(e.day!.toLowerCase() == "sunday")
                  {
                    e.sortOrder =7
                  }


    });
    print(this.salon.value.availabilityHours);
    this.salon.value.availabilityHours!.sort((a, b) => a.sortOrder!.compareTo(b.sortOrder!));

  }

  Future getReviews() async {
    try {
      reviews.assignAll(await _salonRepository.getReviews());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getOptionGroups() async {
    try {
     // var _availabilityHours = await _salonRepository.getAvailabilityHour(salon.value.id);

      availabilityHours.assignAll(salon.value.availabilityHours!);
     // return optionGroups;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
