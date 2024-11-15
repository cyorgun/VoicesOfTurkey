import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistrictModel {
  final String? name;
  final List<List<LatLng>?>? polygonPoints;
  final LatLng? centerCoordinates;

  DistrictModel({this.name, this.polygonPoints, this.centerCoordinates});
}
