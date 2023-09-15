import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../models/salon_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/duration_chip_widget.dart';
import '../../global_widgets/salon_availability_badge_widget.dart';
import '../controllers/salon_controller.dart';
import '../widgets/salon_option_group_item_widget.dart';
import '../widgets/salon_til_widget.dart';
import '../widgets/salon_title_bar_widget.dart';


class SalonView extends GetView<SalonController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _salon = controller.salon.value;
      if (!_salon.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.edit_outlined, size: 28, color: Get.theme.primaryColor),
            onPressed: () => {
              Get.offAndToNamed(Routes.SALON_FORM, arguments: {'salon': _salon})
            },
            backgroundColor: Get.theme.colorScheme.secondary,
          ),
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshEService(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildSalonTitleBarWidget(_salon),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_salon),
                            buildCarouselBullets(_salon),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildCategories(_salon),

                        SalonTilWidget(
                          title: Text("Address".tr, style: Get.textTheme.subtitle2),
                          content: Obx(() {
                            /*if (controller.salon.value?.address?.address == '') {
                              return SizedBox();
                            }*/
                            final address = controller.salon.value?.address?.address;
                            if (address == null || address.isEmpty) {
                              return SizedBox();
                            }
                            return Ui.applyHtml(address, style: Get.textTheme.bodyText1);
                          }),
                        ),
                        SalonTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Obx(() {
                            if (controller.salon.value.description == '') {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_salon.description!, style: Get.textTheme.bodyText1);
                          }),
                        ),
                        buildOptions(_salon),
                        if (_salon.images!.isNotEmpty)
                          SalonTilWidget(
                            horizontalPadding: 0,
                            title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                            content: Container(
                              height: 120,
                              child: ListView.builder(
                                  primary: false,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _salon.images!.length,
                                  itemBuilder: (_, index) {
                                    var _media = _salon.images!.elementAt(index);
                                    return InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.GALLERY, arguments: {'media': _salon.images, 'current': _media, 'heroTag': 'e_services_galleries'});
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                                        child: Stack(
                                          alignment: AlignmentDirectional.topStart,
                                          children: [
                                            Hero(
                                              tag: 'e_services_galleries' + _media.id!,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: CachedNetworkImage(
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  imageUrl: _media.thumb!,
                                                  placeholder: (context, url) => Image.asset(
                                                    'assets/img/loading.gif',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 100,
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                                              child: Text(
                                                _media.name ?? '',
                                                maxLines: 2,
                                                style: Get.textTheme.bodyText2?.merge(TextStyle(
                                                  color: Get.theme.primaryColor,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(0, 1),
                                                      blurRadius: 6.0,
                                                      color: Get.theme.hintColor.withOpacity(0.6),
                                                    ),
                                                  ],
                                                )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            actions: [
                              // TODO View all galleries
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Widget buildOptions(Salon _salon) {
    controller.SorteAvailabilityHour();
    return Obx(() {
      if (controller.salon.value.availabilityHours!.isEmpty) {
        return SalonTilWidget(
          title: Text("Open Hours".tr, style: Get.textTheme.subtitle2),
          content: Center(
              child: Text(
                "No Availability hour assigned to this salon".tr,
            style: Get.textTheme.caption,
          ).paddingSymmetric(vertical: 15)),
          actions: [
            GestureDetector(
              onTap: () {
                Get.offAndToNamed(Routes.SALON_OPTIONS_FORM, arguments: {'salon': _salon});
              },
              child: Text("Add Open Hours".tr, style: Get.textTheme.subtitle1),
            ),
          ],
        );
      }
      return SalonTilWidget(
        horizontalPadding: 0,
        title: Text("Open Hours".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
        content: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {

            return SalonOptionGroupItemWidget(availabilityHour: controller.salon.value.availabilityHours!.elementAt(index), salon: controller.salon.value);
          },
          separatorBuilder: (context, index) {
            return Divider(height: 16, thickness: 0.8);
          },
          itemCount: controller.salon.value.availabilityHours!.length,
          primary: false,
          shrinkWrap: true,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.offAndToNamed(Routes.SALON_OPTIONS_FORM, arguments: {'salon': _salon});
            },
            child: Text("Add Open Hours".tr, style: Get.textTheme.subtitle1),
          ).paddingSymmetric(horizontal: 20),
        ],
      );
    });
  }

  CarouselSlider buildCarouselSlider(Salon _salon) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _salon.images?.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _salon.id!,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url!,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Salon _salon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _salon.images!.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _salon.images!.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  SalonTitleBarWidget buildSalonTitleBarWidget(Salon _salon) {
    return SalonTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _salon.name ?? '',
                  style: Get.textTheme.headline5?.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              SalonAvailabilityBadgeWidget(salon: _salon)
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: DurationChipWidget(duration: _salon.distance.toString()),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 5,
                children: [
                 /* if (_eService.getOldPrice > 0)
                    Ui.getPrice(
                      _eService.getOldPrice,
                      style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                    ),
                  Ui.getPrice(
                    _eService.getPrice,
                    style: Get.textTheme.headline3.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                  ),*/
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories(Salon _salon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(1, (index) {
          var _category = _salon.salonLevel;
          var categoryName = _category?.name ?? "";
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(categoryName, style: Get.textTheme.bodyText1?.merge(TextStyle(color: Colors.green))),
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            })

      ),
    );
  }
}
