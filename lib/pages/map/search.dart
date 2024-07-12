import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/search_cubit.dart';
import 'package:locomotive21/cubit/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async {
        context.read<SearchCubit>().resetSearch();
      },
      child: Scaffold(
        body: ListView(children: [
          Container(
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
                    controller: _search,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Cari event ...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().search(_search.text);
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 200,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is SearchSuccess) {
                  if (state.events.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var event in state.events)
                          ListTile(
                            onTap: () {
                              Navigator.pop(context, event.latLng);
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                      ],
                    );
                  }
                }
                return const Empty(
                  text: "Tidak ada data",
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class Empty extends StatelessWidget {
  final String text;
  const Empty({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 150,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
