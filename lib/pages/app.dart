import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/pages/account.dart';
import 'package:locomotive21/pages/home.dart';
import 'package:locomotive21/pages/map.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      context.read<EventCubit>().getEvents();
    });

    final IndexedStack pages = IndexedStack(
      index: _currentIndex,
      children: const [
        HomeScreen(),
        MapScreen(),
        AccountScreen(),
      ],
    );

    return Scaffold(
      body: pages,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Peta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
