import 'package:flutter/material.dart';

import 'package:nikki_app/utils/get_it_init.dart';
import 'package:nikki_app/widgets/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetItInitialization().setupGetIt();
  runApp(const NikkiApp());
}

class NikkiApp extends StatefulWidget {
  const NikkiApp({super.key});

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(255, 100, 73, 0.37)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

