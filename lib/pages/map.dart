import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/cubit/event_state.dart';
import 'package:locomotive21/shared/widgets/marker_detail.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;

  LatLng? _currentLocation;
  double _currentZoom = 13.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startListeningToLocationChanges();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _startListeningToLocationChanges() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _positionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
        _mapController.move(_currentLocation!, _currentZoom);
      },
      onError: (error) {
        print("Error: $error");
      },
    );
  }

  double _getMarkerSize({int size = 40}) {
    return size * (_currentZoom / 13);
  }

  @override
  Widget build(BuildContext context) {
    return _currentLocation == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : BlocBuilder<EventCubit, EventState>(builder: (context, state) {
            if (state is EventLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation ?? const LatLng(-5.135185, 119.422717),
                initialZoom: _currentZoom,
                onMapEvent: (MapEvent mapEvent) {
                  if (mapEvent is MapEventMove) {
                    setState(() {
                      _currentZoom = mapEvent.camera.zoom;
                    });
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.locomotive21',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      child: Container(
                        height: _getMarkerSize(),
                        width: _getMarkerSize(),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    if (state is EventSuccess)
                      for (var event in state.events)
                        if (event.status != 'selesai')
                          Marker(
                            point: event.latLng,
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return MarkerDetail(
                                      event: event,
                                      currentLocation: _currentLocation,
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: _getMarkerSize(size: 40),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            );
          });
  }
}
