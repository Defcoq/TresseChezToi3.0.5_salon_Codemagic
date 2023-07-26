import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../models/address_model.dart';
import '../../../models/category_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../models/salon_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/images_field_widget.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/salon_form_controller.dart';
import '../widgets/salon_horizontal_stepper_widget.dart';
import '../widgets/salons_step_widget.dart';


class SalonFormView extends GetView<SalonFormController> {
  @override
  Widget build(BuildContext context) {
    print(controller.salon.value);
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return Text(
              controller.isCreateForm() ? "Create Salon".tr : controller.salon.value.name ?? '',
              style: context.textTheme.headline6,
            );
          }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () async {
              controller.isCreateForm()
                  ? await Get.offAndToNamed(Routes.SALONS)
                  : await Get.offAndToNamed(Routes.SALON, arguments: {'salon': controller.salon.value, 'heroTag': 'service_form_back'});
            },
          ),
          elevation: 0,
          actions: [
            new IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: new Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 28,
              ),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    if (controller.isCreateForm()) {
                      controller.createSalonForm();
                    } else {
                      controller.updateSalonForm();
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary,
                  child: Text("Save".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor))),
                  elevation: 0,
                ),
              ),
              if (controller.isCreateForm()) SizedBox(width: 10),
              if (controller.isCreateForm())
                MaterialButton(
                  onPressed: () {
                    controller.createSalonForm(createOptions: false);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.colorScheme.secondary.withOpacity(0.2),
                  child: Text("Save & Add Options".tr, style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.colorScheme.secondary))),
                  elevation: 0,
                ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
          key: controller.salonForm,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.isCreateForm())
                  SalonsHorizontalStepperWidget(
                    steps: [
                      SalonsStepWidget(
                        title: Text(
                          ("Salon details".tr).substring(0, min("Salon details".tr.length, 15)),
                        ),
                        index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                      SalonsStepWidget(
                        title: Text(
                          ("Options details".tr).substring(0, min("Options details".tr.length, 15)),
                        ),
                        color: Get.theme.focusColor,
                        index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ],
                  ),
                Text("Salon details".tr, style: Get.textTheme.headline5).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Fill the following details and save them".tr, style: Get.textTheme.caption).paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return ImagesFieldWidget(
                    label: "Images".tr,
                    field: 'image',
                    tag: controller.salonForm.hashCode.toString(),
                    initialImages: controller.salon.value.images,
                    uploadCompleted: (uuid) {
                      controller.salon.update((val) {
                        val.images = val.images ?? [];
                        val.images.add(new Media(id: uuid));
                      });
                    },
                    reset: (uuids) {
                      controller.salon.update((val) {
                        val.images.clear();
                      });
                    },
                  );
                }),
                TextFieldWidget(
                  onSaved: (input) => controller.salon.value.name = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  initialValue: controller.salon.value.name,
                  hintText: "Post Party Cleaning".tr,
                  labelText: "Name".tr,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.salon.value.description = input,
                  validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                  keyboardType: TextInputType.multiline,
                  initialValue: controller.salon.value.description,
                  hintText: "Description for Post Party Cleaning".tr,
                  labelText: "Description".tr,
                ),

                Obx(() {
                  if (controller.addresses.length > 1)
                    return Container(
                      padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Addresses".tr,
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  final selectedValue = await showDialog<Address>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SelectDialog(
                                        title: "Select Addresses".tr,
                                        submitText: "Submit".tr,
                                        cancelText: "Cancel".tr,
                                        items: controller.getMultiSelectAddressItems(),
                                        initialSelectedValue: controller.salons.firstWhere(
                                          (element) => element.id == controller.salon.value?.id,
                                          orElse: () => new Salon(),
                                        ),
                                      );
                                    },
                                  );
                                  controller.salon.update((val) {
                                    val.address = selectedValue;
                                  });
                                },
                                shape: StadiumBorder(),
                                color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                                child: Text("Select".tr, style: Get.textTheme.subtitle1),
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                              ),
                            ],
                          ),
                          Obx(() {
                            if (controller.salon.value?.address == null) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Select Addresses".tr,
                                  style: Get.textTheme.caption,
                                ),
                              );
                            } else {
                              return buildAddress(controller.salon.value);
                            }
                          })
                        ],
                      ),
                    );
                  else if (controller.addresses.length == 1) {
                    controller.salon.value.address = controller.addresses.first;
                    return SizedBox();
                  } else {
                    return SizedBox();
                  }
                }),

              ],
            ),
          ),
        ));
  }


  Widget buildAddress(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text(_salon.address?.address ?? '', style: Get.textTheme.bodyText2),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Salon".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This salon will removed from your account".tr, style: Get.textTheme.bodyText1),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyText1),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                controller.deleteSalon();
              },
            ),
          ],
        );
      },
    );
  }
}
