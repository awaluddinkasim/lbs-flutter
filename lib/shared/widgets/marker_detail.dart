import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:locomotive21/models/event.dart';
import 'package:locomotive21/shared/utils/helpers.dart';

class MarkerDetail extends StatelessWidget {
  const MarkerDetail({
    super.key,
    required this.event,
    required LatLng? currentLocation,
  }) : _currentLocation = currentLocation;

  final Event event;
  final LatLng? _currentLocation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Nama Event",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            event.nama,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Deskripsi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            event.deskripsi,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Jarak",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "${calculateDistance(_currentLocation!, event.latLng)} km",
          ),
        ],
      ),
    );
  }
}
