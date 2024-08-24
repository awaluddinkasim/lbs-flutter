import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/cubit/event_state.dart';
import 'package:locomotive21/cubit/location_cubit.dart';
import 'package:locomotive21/shared/widgets/marker_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.changePage});

  final Function changePage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<EventCubit>().getEvents();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 34),
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    24,
                  ),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Selamat datang",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        "Locomotive 21",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  "Daftar Event",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TabBar(
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: 'Event Aktif',
                    ),
                    Tab(
                      text: 'Event Selesai',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BlocBuilder<EventCubit, EventState>(
                        builder: (context, state) {
                          if (state is EventLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is EventSuccess) {
                            if (state.events.where((event) => event.status == 'aktif').isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Belum ada event",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var event
                                    in state.events.where((event) => event.status == 'aktif'))
                                  ListTile(
                                    onTap: () {
                                      context.read<LocationCubit>().setLocation(event.latLng);

                                      widget.changePage(1);
                                    },
                                    leading: const Icon(Icons.event),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          event.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(event.lokasi,
                                            maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            return const Text("Terjadi kesalahan");
                          }
                        },
                      ),
                      BlocBuilder<EventCubit, EventState>(
                        builder: (context, state) {
                          if (state is EventLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is EventSuccess) {
                            if (state.events.where((event) => event.status == 'selesai').isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text(
                                  "Belum ada event",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var event
                                    in state.events.where((event) => event.status == 'selesai'))
                                  ListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return MarkerDetail(
                                            event: event,
                                          );
                                        },
                                      );
                                    },
                                    leading: const Icon(Icons.event),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          event.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(event.lokasi,
                                            maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            return const Text("Terjadi kesalahan");
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
