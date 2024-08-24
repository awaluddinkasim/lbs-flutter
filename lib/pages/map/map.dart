import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/cubit/event_state.dart';
import 'package:locomotive21/cubit/location_cubit.dart';
import 'package:locomotive21/pages/map/search.dart';
import 'package:locomotive21/shared/services/direction.dart';
import 'package:locomotive21/shared/widgets/marker_detail.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;

  late LatLng _initialLocation;
  LatLng? _currentLocation;
  double _currentZoom = 13.0;

  List<LatLng> _points = [];

  Future<void> _getCoordinates(String from, String to) async {
    List result = await DirectionService.getDirection(from, to);

    setState(() {
      _points = result.map((e) => LatLng(e[1], e[0])).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startListeningToLocationChanges();

    Future.delayed(Duration.zero, () {
      BlocProvider.of<EventCubit>(context).getEvents();
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    _initialLocation = context.read<LocationCubit>().state;

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
    } catch (_) {}
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      },
    );
  }

  double _getMarkerSize({int size = 40}) {
    return size * (_currentZoom / 13);
  }

  @override
  Widget build(BuildContext context) {
    context.read<LocationCubit>().resetLocation();

    return Stack(
      children: [
        _currentLocation == null
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
                    initialCenter: _initialLocation != const LatLng(0, 0)
                        ? _initialLocation
                        : _currentLocation ?? const LatLng(-5.135185, 119.422717),
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
                    PolylineLayer(polylines: [
                      Polyline(
                        points: _points,
                        strokeWidth: 4,
                        color: Colors.blue,
                      ),
                    ]),
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
                                rotate: true,
                                alignment: Alignment.topCenter,
                                point: event.latLng,
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
                                    ).then((to) {
                                      if (to != null) {
                                        _getCoordinates(
                                          "${_currentLocation!.longitude},${_currentLocation!.latitude}",
                                          "$to",
                                        );
                                      } else {
                                        setState(() {
                                          _points = [];
                                        });
                                      }
                                    });
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
              }),
        SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.only(left: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 2,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      ).then((location) {
                        if (location != null) {
                          _mapController.move(location, _currentZoom);
                        }
                      });
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Cari event ...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    ).then((location) {
                      if (location != null) {
                        _mapController.move(location, _currentZoom);
                      }
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
