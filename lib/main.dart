import 'package:flutter/material.dart';
import 'package:plantrecognition_app/models/plant_model.dart';
import 'package:plantrecognition_app/pages/account_page.dart';
import 'package:plantrecognition_app/pages/homepage.dart';
import 'package:plantrecognition_app/pages/camera_page.dart';
import 'package:plantrecognition_app/pages/login_page.dart';
import 'package:plantrecognition_app/pages/plant_results_page.dart';
import 'package:plantrecognition_app/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Charger les variables d'environnement (tolérant si le fichier manque)
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {
    // Ignorer en dev si le fichier .env est absent
  }

  // Important: initialiser Supabase AVANT tout runApp pour capter les deep links Android
  await Supabase.initialize(
    url: 'https://ovtmkvvrevlcxmgpmmmw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im92dG1rdnZyZXZsY3htZ3BtbW13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0OTc2MzksImV4cCI6MjA3MzA3MzYzOX0.YBvXx2p2F0Ra2D9EB5vVV1iNhlreFHltTNeSFKvKBI8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Vérification des variables d'environnement (à retirer en production)
  print('PlantNet API Key loaded: ${dotenv.env['PLANTNET_API_KEY'] != null}');
  print('PlantNet Base URL: ${dotenv.env['PLANTNET_BASE_URL']}');

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
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF4CAF50),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2E7D32),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF2E7D32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCED4DA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFCED4DA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212529),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF212529),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF6C757D),
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
        '/plant_results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as PlantIdentificationResponse;
          return PlantResultsPage(identificationResult: args);
        }
      },
    );
  }
}