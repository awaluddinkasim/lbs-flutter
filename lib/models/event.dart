import 'package:latlong2/latlong.dart';

class Event {
  final String nama;
  final String lokasi;
  final String deskripsi;
  final String tanggalMulai;
  final String tanggalSelesai;
  final int jumlahHari;
  final double latitude;
  final double longitude;
  final String trailer;
  final int hargaTiket;
  final String poster;
  final String status;
  final String contactPerson;
  late LatLng latLng;

  Event({
    required this.nama,
    required this.lokasi,
    required this.deskripsi,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.jumlahHari,
    required this.latitude,
    required this.longitude,
    required this.trailer,
    required this.hargaTiket,
    required this.poster,
    required this.contactPerson,
    required this.status,
  }) {
    latLng = LatLng(latitude, longitude);
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      nama: json['nama'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      jumlahHari: json['jumlah_hari'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      trailer: json['trailer'],
      hargaTiket: json['harga_tiket'],
      poster: json['poster'],
      contactPerson: json['contact_person'],
      status: json['status'],
    );
  }
}
