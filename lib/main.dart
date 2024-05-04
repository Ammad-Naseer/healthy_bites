import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthy_bites/Provider/match_data_provider.dart';
import 'package:healthy_bites/Provider/login_sharedpreference_provider.dart';
import 'package:healthy_bites/Provider/theme_changer_provider.dart';
import 'package:healthy_bites/Screens/auth.dart';
import 'package:healthy_bites/Screens/on_boarding_screen.dart';
import 'package:healthy_bites/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (BuildContext context) => Matchdate()),
    ChangeNotifierProvider(create: (BuildContext context) => ThemeChanger()),
    ChangeNotifierProvider(
        create: (BuildContext context) => LoginSharedPreferenceProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isLogin = false;

  @override
  void initState() {
    Provider.of<LoginSharedPreferenceProvider>(context, listen: false)
        .getValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (kDebugMode) {
              print("Something went wrong");
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Builder(builder: (BuildContext context) {
            return Consumer<LoginSharedPreferenceProvider>(
                builder: (context, provider, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Healthy Bites',
                themeMode: Provider.of<ThemeChanger>(context).themeMode,
                theme: ThemeData(brightness: Brightness.light),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                ),
                home: provider.getBoolLogin == true
                    ? const LandingPage()
                    : const On_Boarding_screen(),
              );
            });
          });
        });
  }
}
