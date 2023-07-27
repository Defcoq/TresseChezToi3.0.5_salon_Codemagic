/*
 * Copyright (c) 2020 .
 */

import 'package:beauty_clud_salon_owner/app/modules/salons/widgets/salon_option_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/availability_hour_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/salon_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/salon_controller.dart';


class SalonOptionGroupItemWidget extends GetWidget<SalonController> {
  SalonOptionGroupItemWidget({
    required AvailabilityHour availabilityHour,
    required Salon salon
  }) : _availabilityHour = availabilityHour,_salon = salon;


  final AvailabilityHour _availabilityHour;
  final Salon _salon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      Get.offAndToNamed(Routes.SALON_OPTIONS_FORM, arguments: {'salon': new Salon(id: _salon.id), 'availability': _availabilityHour});
    },
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(_availabilityHour.day!.tr.capitalizeFirst!).paddingSymmetric(vertical: 5),
                ] +
                    List.generate(1, (index) {
                      return Text(
                        _availabilityHour.data!,
                        style: Get.textTheme.caption,
                      );
                    }),
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Column(
              children: List.generate(1, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  width: 125,
                  child: Text(
                    _availabilityHour.startAt! + "-" + _availabilityHour.endAt!,
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.focusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                );
              }),
              //mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          ],
        )
    );
  }
}
