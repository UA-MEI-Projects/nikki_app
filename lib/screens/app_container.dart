import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nikki_app/screens/camera.dart';
import 'package:nikki_app/screens/map.dart';
import 'package:nikki_app/screens/settings.dart';
import 'package:nikki_app/screens/share.dart';

import '../domain/bloc/diary_entry_cubit.dart';
import '../domain/repository/user_repository.dart';
import '../utils/get_it_init.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<StatefulWidget> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int screenIndex = 0;

  final screens = [
    CameraScreen(),
    MapScreen(),
    ShareScreen(),
    SettingsScreen()
  ];

  void onNavigate(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  Future<bool> _handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _handleLocationPermission(context);
    return BlocProvider(
      create: (context) => getIt.get<DiaryEntryCubit>(),
      child: Scaffold(
          extendBody: true,
          body: screens[screenIndex],
          bottomNavigationBar: BottomNavigationBar(
              iconSize: 35.0,
              elevation: 1,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
              unselectedItemColor: Theme.of(context).colorScheme.inverseSurface,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: screenIndex,
              onTap: onNavigate,
              items: const [
                BottomNavigationBarItem(
                    label: 'Camera', icon: Icon(Icons.camera_alt)),
                BottomNavigationBarItem(label: 'Map', icon: Icon(Icons.map)),
                BottomNavigationBarItem(
                    label: 'Share', icon: Icon(Icons.share)),
                BottomNavigationBarItem(
                    label: 'Settings', icon: Icon(Icons.settings)),
              ])),
    );
  }
}
