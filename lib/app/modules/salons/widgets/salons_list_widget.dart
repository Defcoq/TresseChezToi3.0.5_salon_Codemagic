import 'package:beauty_clud_salon_owner/app/modules/salons/widgets/salons_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/salons_controller.dart';


class SalonsListWidget extends GetView<SalonsController> {
  SalonsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.salons.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.salons.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.salons.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _salon = controller.salons.elementAt(index);
              return SalonsListItemWidget(salon: _salon);
            }
          }),
        );
      }
    });
  }
}
