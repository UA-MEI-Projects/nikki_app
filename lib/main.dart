import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nikki_app/screens/camera.dart';
import 'package:nikki_app/screens/map.dart';
import 'package:nikki_app/screens/settings.dart';
import 'package:nikki_app/screens/share.dart';
import 'package:nikki_app/utils/get_it_init.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'db/nikki_shared_pref.dart';
import 'model/diary_entry_model.dart';
import 'utils/get_it_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetItInitialization().setupGetIt();

  runApp(ChangeNotifierProvider(
    create: (context) => DiaryEntryModel(),
    child: NikkiApp(),
  ));
}

class NikkiApp extends StatefulWidget {
  const NikkiApp({Key? key}) : super(key: key);

  @override
  State<NikkiApp> createState() => _NikkiAppState();
}

class _NikkiAppState extends State<NikkiApp> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nikki',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: AppContainer(),
    );
  }
}

class AppContainer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int screenIndex = 0;
  final screens = [CameraScreen(), MapScreen(), ShareScreen(), SettingsScreen()];
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
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }  permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }  if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }  return true;
  }

  @override
  Widget build(BuildContext context) {
    _handleLocationPermission(context);
    return Scaffold(
        extendBody: true,
        body: screens[screenIndex],
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 35.0,
            elevation: 1,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: screenIndex,
            onTap: onNavigate,
            items: [
              BottomNavigationBarItem(
                  label: 'Camera', icon: Icon(Icons.camera_alt)),
              BottomNavigationBarItem(
                  label: 'Map', icon: Icon(Icons.map)),
              BottomNavigationBarItem(
                  label: 'Share', icon: Icon(Icons.share)),
              BottomNavigationBarItem(
                  label: 'Settings', icon: Icon(Icons.settings)),
        ])
    );
  }
}

