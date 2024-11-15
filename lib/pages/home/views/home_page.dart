import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:voices_of_turkey/colors/app_colors.dart';
import 'package:voices_of_turkey/pages/home/controllers/home_controller.dart';

import '../../../models/DistrictModel.dart';
import '../../../models/ItemModel.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/custom_widgets/app_bar.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(titleWidget: Obx(() => createDistrictDropdownWidget())),
      body: Obx(
        () => Stack(children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) =>
                _controller = controller,
            mapToolbarEnabled: false,
            initialCameraPosition: CameraPosition(
              target: controller.defaultLocation,
              zoom: 14,
            ),
            onTap: (position) {
              controller.onMapClicked(false);
            },
            markers: createMarkersFromList(),
            polygons: controller.selectedDistrict.value.polygonPoints != null
                ? controller.selectedDistrict.value.polygonPoints!
                    .map<Polygon>((element) => Polygon(
                        polygonId: PolygonId(controller
                            .selectedDistrict.value.polygonPoints!
                            .indexOf(element)
                            .toString()),
                        points: element!,
                        fillColor: const Color(0xFF006491).withOpacity(0.2),
                        strokeWidth: 2))
                    .toSet()
                : {},
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  color: AppColors.background,
                  border: Border.symmetric(
                      horizontal:
                          BorderSide(color: AppColors.mainColor2, width: 2))),
              height: 120,
              child: controller.selectedItemType.value == ItemType.none
                  ? createItemSelectionWidget()
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.selectedItemType.value = ItemType.none;
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.iconColor,
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: createItemList(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ]),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: AppColors.backgroundGradient,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Set<Marker> createMarkersFromList() {
    var list = controller.itemList
        .where((element) =>
            element.district == controller.selectedDistrict.value.name)
        .toList();
    return list
        .map(
          (element) => Marker(
              markerId: MarkerId(element.name),
              infoWindow: InfoWindow(
                  title: element.name,
                  onTap: () {
                    Get.toNamed(Routes.DETAILS, arguments: {
                      "name": element.name,
                      "description": element.description,
                      "imageAddress": element.imageAddress
                    });
                  }),
              position: LatLng(element.latitude, element.longitude),
              icon: element.customIcon,
              onTap: () {
                onItemClick(element);
              }),
        )
        .toSet();
  }

  onItemClick(ItemModel element) {
    controller.itemList.forEach((element2) {
      if (element2.name != element.name) {
        element2.isOnFocus = false;
        element2.setCustomMarker();
      }
    });
    element.onItemClicked();
    controller.itemList.refresh();
  }

  List<Container> createItemList() {
    var list = controller.itemList
        .where((element) =>
            element.itemType == controller.selectedItemType.value &&
            element.district == controller.selectedDistrict.value.name)
        .toList();
    return list
        .map(
          (element) => Container(
            width: 90,
            margin: const EdgeInsets.only(left: 8, right: 8, top: 3),
            child: GestureDetector(
              onTap: () {
                onItemClick(element);
                _controller.showMarkerInfoWindow(MarkerId(element.name));
                _controller.animateCamera(CameraUpdate.newLatLng(
                    LatLng(element.latitude, element.longitude)));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  element.imageAddress != null
                      ? Expanded(
                          child: Image.network(
                          element.imageAddress!,
                          fit: BoxFit.cover,
                        ))
                      : Expanded(
                          child: Icon(
                          Icons.restaurant_menu,
                          color: AppColors.iconColor,
                          size: 40,
                        )),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    height: 25,
                    child: AutoSizeText(
                      element.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold),
                      minFontSize: 9,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget createDistrictDropdownWidget() {
    return DropdownButton<DistrictModel>(
      value: controller.selectedDistrict.value,
      elevation: 5,
      iconEnabledColor: Colors.white,
      items: controller.districtList
          .map<DropdownMenuItem<DistrictModel>>((DistrictModel value) {
        return DropdownMenuItem<DistrictModel>(
          value: value,
          child: Text(
            value.name ?? "?",
          ),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return controller.districtList.map<Widget>((DistrictModel item) {
          return Container(
              alignment: Alignment.center,
              width: 100,
              child: AutoSizeText(
                maxLines: 1,
                item.name ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textColor),
              ));
        }).toList();
      },
      onChanged: (DistrictModel? value) {
        if (value != null) {
          controller.selectedDistrict.value = value;
        }
        if (controller.selectedDistrict.value.centerCoordinates != null) {
          _controller.animateCamera(CameraUpdate.newLatLng(
              controller.selectedDistrict.value.centerCoordinates!));
        }
      },
    );
  }

  Row createItemSelectionWidget() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.selectedItemType.value = ItemType.artifact;
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.account_balance,
                          color: AppColors.iconColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Tarihi Eserler",
                    style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: AppColors.iconColor,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.selectedItemType.value = ItemType.restaurant;
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.restaurant,
                          color: AppColors.iconColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Restoranlar",
                    style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        VerticalDivider(
          width: 1,
          color: AppColors.iconColor,
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.selectedItemType.value = ItemType.hotel;
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.hotel,
                          color: AppColors.iconColor,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Oteller",
                    style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
