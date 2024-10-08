import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:locomotive21/models/event.dart';
import 'package:locomotive21/pages/event/event.dart';
import 'package:locomotive21/shared/constants.dart';
import 'package:locomotive21/shared/utils/helpers.dart';
import 'package:locomotive21/shared/widgets/poster.dart';

class MarkerDetail extends StatelessWidget {
  const MarkerDetail({
    super.key,
    required this.event,
    LatLng? currentLocation,
  }) : _currentLocation = currentLocation;

  final Event event;
  final LatLng? _currentLocation;

  @override
  Widget build(BuildContext context) {
    final number = NumberFormat();
    final decimal = NumberFormat('#.##');

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
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black12,
              ),
              child: Stack(
                children: [
                  Hero(
                    tag: event.poster,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PosterImage(
                              img: event.poster,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        "${Constants.baseUrl}/poster/${event.poster}",
                        fit: BoxFit.cover,
                        height: 350,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (_currentLocation != null)
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
                              "${decimal.format(calculateDistance(_currentLocation, event.latLng))} km",
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
            event.hargaTiket > 0 ? "Rp. ${number.format(event.hargaTiket)}" : "Gratis",
          ),
          const SizedBox(
            height: 12,
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventScreen(event: event),
                ),
              );
            },
            child: const Text("Lihat Detail"),
          ),
          if (event.status != 'selesai')
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context, "${event.latLng.longitude},${event.latLng.latitude}");
              },
              icon: const Icon(Icons.directions),
              label: const Text("Rute"),
            ),
        ],
      ),
    );
  }
}
