import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class LocationCubit extends Cubit<LatLng> {
  LocationCubit() : super(const LatLng(0, 0));

  void setLocation(LatLng location) {
    emit(location);
  }

  void resetLocation() {
    emit(const LatLng(0, 0));
  }
}
