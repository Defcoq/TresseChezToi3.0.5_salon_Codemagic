/*
 * Copyright (c) 2020 .
 */

import 'package:beauty_clud_salon_owner/app/modules/salons/widgets/salon_options_popup_menu_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/salon_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/duration_chip_widget.dart';
import '../../global_widgets/salon_availability_badge_widget.dart';


class SalonsListItemWidget extends StatelessWidget {
  const SalonsListItemWidget({
    Key? key,
    required Salon salon,
  })  : _salon = salon,
        super(key: key);

  final Salon _salon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SALON, arguments: {'salon': _salon, 'heroTag': 'salon_services_list_item'});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Hero(
                  tag: 'salon_services_list_item' + _salon.id!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: _salon.firstImageUrl,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 80,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
                SalonAvailabilityBadgeWidget(salon: _salon, withImage: true),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _salon.name ?? '',
                          style: Get.textTheme.bodyText2,
                          maxLines: 3,
                          // textAlign: TextAlign.end,
                        ),
                      ),
                      SalonOptionsPopupMenuWidget(salon: _salon),
                    ],
                  ),
                  Divider(height: 8, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DurationChipWidget(duration: "24/24"),
                     /* Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (0 >= 0)
                            Ui.getPrice(
                              0,
                              style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                            ),
                          Ui.getPrice(
                            0,
                            style: Get.textTheme.headline6,
                          ),
                        ],
                      ),*/
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 18,
                        color: Get.theme.focusColor,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          _salon.name!,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Get.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 18,
                        color: Get.theme.focusColor,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          _salon.address!.address!,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Get.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 8, thickness: 1),
                  Wrap(
                    spacing: 5,
                    children: List.generate(1, (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Text(_salon.salonLevel!.name!, style: Get.textTheme.caption?.merge(TextStyle(fontSize: 10))),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                      );
                    }),
                    runSpacing: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
