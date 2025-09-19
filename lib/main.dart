import 'package:flutter/material.dart';
import 'package:plantrecognition_app/pages/account_page.dart';
import 'package:plantrecognition_app/pages/homepage.dart';
import 'package:plantrecognition_app/pages/camera_page.dart';
import 'package:plantrecognition_app/pages/login_page.dart';
import 'package:plantrecognition_app/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Important: initialiser Supabase AVANT tout runApp pour capter les deep links Android
  await Supabase.initialize(
    url: 'https://ovtmkvvrevlcxmgpmmmw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im92dG1rdnZyZXZsY3htZ3BtbW13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0OTc2MzksImV4cCI6MjA3MzA3MzYzOX0.YBvXx2p2F0Ra2D9EB5vVV1iNhlreFHltTNeSFKvKBI8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Recognition App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.green),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/account': (context) => const AccountPage(),
        '/homepage': (context) => const HomePage(),
        '/camera': (context) => const CameraPage(),
      },
    );
  }
}