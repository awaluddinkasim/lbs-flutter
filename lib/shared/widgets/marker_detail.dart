import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:locomotive21/models/event.dart';
import 'package:locomotive21/pages/event/event.dart';
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
    final number = NumberFormat('#.##');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 350,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Wrap(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${number.format(calculateDistance(_currentLocation!, event.latLng))} km",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          const Text(
            "Nama Event",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
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
              fontSize: 18,
            ),
          ),
          Text(
            event.deskripsi,
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Tanggal Event",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (event.jumlahHari > 1)
            Text(
              "${event.tanggalMulai} - ${event.tanggalSelesai}",
            )
          else
            Text(event.tanggalMulai),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Harga Tiket",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            event.hargaTiket > 0 ? "Rp. ${event.hargaTiket}" : "Gratis",
          ),
          const SizedBox(
            height: 12,
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventScreen(),
                ),
              );
            },
            child: const Text("Lihat Detail"),
          ),
        ],
      ),
    );
  }
}
