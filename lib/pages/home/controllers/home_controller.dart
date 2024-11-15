import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:voices_of_turkey/models/ItemModel.dart';

import '../../../models/DistrictModel.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final RxList<ItemModel> itemList = <ItemModel>[].obs;
  final Rx<ItemType> selectedItemType = Rx<ItemType>(ItemType.none);
  List<DistrictModel> districtList = [];
  final Rx<DistrictModel> selectedDistrict = DistrictModel().obs;
  final defaultLocation = const LatLng(41.015137, 28.979530);
  final _db = FirebaseFirestore.instance;
  final defaultDistrictNumber = 33;

  @override
  void onInit() {
    super.onInit();
    createDistrictModels();
    createItemModels();
    locationSetup();
  }

  void onMapClicked(bool newState) {
    itemList.forEach((element) {
      element.isOnFocus = false;
      //element.setCustomMarker();
    });
    itemList.refresh();
  }

  void createDistrictModels() async {
    final String response =
        await rootBundle.loadString('assets/json/istanbul_districts.json');
    final data = await json.decode(response);
    districtList = jsonToWidget(data);
    selectedDistrict.value = districtList[defaultDistrictNumber];
  }

  void createItemModels() async {
    itemList.value = await getItems();
    for (var element in itemList) {
      await element.setCustomMarker();
    }
    itemList.refresh();
  }

  Future<List<ItemModel>> getItems() async {
    final artifactsSnapshot = await _db.collection("Artifacts").get();
    final artifactsData = artifactsSnapshot.docs
        .map((element) => ItemModel.fromSnapshot(element))
        .toList();
    final restaurantsSnapshot = await _db.collection("Restaurants").get();
    final restaurantsData = restaurantsSnapshot.docs
        .map((element) => ItemModel.fromSnapshot(element))
        .toList();
    return artifactsData + restaurantsData;
  }

  List<DistrictModel> jsonToWidget(data) {
    List<DistrictModel> districtModels = [];
    for (int i = 0; i < data["features"].length; i++) {
      var districtName = data["features"][i]["properties"]["name"];
      var centerList = data["features"][i]["geometry"]["center"];
      var centerCoordinates = LatLng(centerList[0], centerList[1]);
      var type = data["features"][i]["geometry"]["type"];
      if (type == "MultiPolygon") {
        List<List<LatLng>> multiPolygonPoints = [];
        for (int j = 0;
            j < data["features"][i]["geometry"]["coordinates"].length;
            j++) {
          var districtPolygons =
              data["features"][i]["geometry"]["coordinates"][j][0];
          var polygonPoints = districtPolygons
              .map<LatLng>((element) => LatLng(element[1], element[0]))
              .toList();
          multiPolygonPoints.add(polygonPoints);
        }
        districtModels.add(DistrictModel(
            name: districtName,
            polygonPoints: multiPolygonPoints,
            centerCoordinates: centerCoordinates));
      } else {
        var districtPolygons =
            data["features"][i]["geometry"]["coordinates"][0];
        var polygonPoints = districtPolygons
            .map<LatLng>((element) => LatLng(element[1], element[0]))
            .toList();
        districtModels.add(DistrictModel(
            name: districtName,
            polygonPoints: [polygonPoints],
            centerCoordinates: centerCoordinates));
      }
    }
    return districtModels;
  }

  void locationSetup() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.enableBackgroundMode(enable: true);
    //TODO: Ekle bunu
/*    location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 10000, distanceFilter: 20);*/

    location.onLocationChanged.listen((LocationData currentLocation) {
      if (Get.currentRoute == Routes.CALL) {
        return;
      }
      var lat1 = currentLocation.latitude;
      var lon1 = currentLocation.longitude;
      ItemModel? item;
      try {
        item = itemList.firstWhere((element) =>
            element.itemType == ItemType.artifact &&
            calculateDistanceAsMeters(
                    lat1, lon1, element.latitude, element.longitude) <
                200);
      } catch (_) {}
      if (item != null) {
        var text = "";
        try {
          text = (item.description!.length > 3000
              ? item.description!.substring(0, 3000)
              : item.description)!;
        } catch (_) {}
        Get.toNamed(Routes.CALL, arguments: {
          "name": item.name,
          "description": text,
          "imageAddress": item.imageAddress
        });
      }
    });
  }

  double calculateDistanceAsMeters(lat1, lon1, lat2, lon2) {
    var p =
        0.017453292519943295; //conversion factor from radians to decimal degrees, exactly math.pi/180
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var radiusOfEarth = 6371;
    return 1000 * radiusOfEarth * 2 * asin(sqrt(a));
  }
}
