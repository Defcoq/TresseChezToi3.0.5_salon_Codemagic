import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../routes/app_routes.dart';
import '../controllers/country_selection_controller.dart';

class CountrySelectionView extends GetView<CountrySelectionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select TresseChezToi Zone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please select your TresseChezToi Zone:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Obx(() => Column(
              children: controller.clients.keys.map((client) {
                return RadioListTile<String>(
                  title: Text(controller.getDescription(client)),
                  value: client,
                  groupValue: controller.selectedClient.value,
                  onChanged: (selectedClient) {
                    controller.setSelectedClient(selectedClient!);
                  },
                );
              }).toList(),
            )),
            ElevatedButton(
              onPressed: () async {
                if (controller.selectedClient.isNotEmpty) {
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  // Perform initialization in the background
                  await controller.initServices();

                  // Dismiss the loading indicator
                  Navigator.pop(context);

                  // Navigate to the root page
                  Get.toNamed(Routes.ROOT);
                } else {
                  Get.snackbar('Error', 'Please select a zone');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

/*class CountrySelectionView extends GetView<CountrySelectionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select TresseChezToi Zone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please select your TresseChezToi Zone:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Obx(() => Column(
              children: controller.clients.keys.map((client) {
                return RadioListTile<String>(
                  title: Text(controller.getDescription(client)),
                  value: client,
                  groupValue: controller.selectedClient.value,
                  onChanged: (selectedClient) {
                    controller.setSelectedClient(selectedClient!);
                  },
                );
              }).toList(),
            )
            ),


            ElevatedButton(
              onPressed: () async {
                if (controller.selectedClient.isNotEmpty) {
                  await controller.initServices();
                  Get.toNamed(Routes.ROOT);
                } else {
                  Get.snackbar('Error', 'Please select a zone');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}*/