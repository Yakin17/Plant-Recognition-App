import 'package:flutter/material.dart';
import 'package:plantrecognition_app/pages/account_page.dart';
import 'package:plantrecognition_app/pages/login_page.dart';
import 'package:plantrecognition_app/pages/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Afficher immédiatement un écran minimal
  runApp(const InitialSplashScreen());
  
  // Initialiser Supabase en arrière-plan
  await _initializeApp();
  
  // Lancer l'app principale une fois initialisée
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  try {
    // Délai pour permettre l'affichage initial
    await Future.delayed(const Duration(milliseconds: 100));
    
    await Supabase.initialize(
      url: 'https://ovtmkvvrevlcxmgpmmmw.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im92dG1rdnZyZXZsY3htZ3BtbW13Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc0OTc2MzksImV4cCI6MjA3MzA3MzYzOX0.YBvXx2p2F0Ra2D9EB5vVV1iNhlreFHltTNeSFKvKBI8',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    
    print('Supabase initialized successfully');
  } catch (e) {
    print('Supabase initialization error: $e');
  }
}

final supabase = Supabase.instance.client;

// Écran de démarrage minimal pour l'initialisation
class InitialSplashScreen extends StatelessWidget {
  const InitialSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green[800],
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Plant Recognition',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Recognition App',
      debugShowCheckedModeBanner: false, // Désactiver la bannière debug
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
      },
    );
  }
}