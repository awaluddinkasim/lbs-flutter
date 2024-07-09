import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

double calculateDistance(LatLng point1, LatLng point2) {
  return Geolocator.distanceBetween(
          point1.latitude, point1.longitude, point2.latitude, point2.longitude) /
      1000;
}
