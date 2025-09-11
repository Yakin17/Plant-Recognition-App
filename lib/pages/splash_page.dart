import 'package:flutter/material.dart';
import 'package:plantrecognition_app/main.dart';
import 'package:flutter/foundation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isRedirecting = false;

  @override
  void initState() {
    super.initState();
    // Utiliser un post-frame callback pour éviter le blocage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirect();
    });
  }

  Future<void> _redirect() async {
    if (_isRedirecting) return;
    _isRedirecting = true;

    // Délai minimal pour permettre le rendu
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) {
      _isRedirecting = false;
      return;
    }

    try {
      // Vérification rapide de la session
      final hasSession = supabase.auth.currentSession != null;
      
      if (hasSession) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/account');
        }
        _isRedirecting = false;
        return;
      }

      // Seulement sur web: récupération de session depuis URL
      if (kIsWeb) {
        try {
          await supabase.auth.getSessionFromUrl(Uri.base);
          if (supabase.auth.currentSession != null && mounted) {
            Navigator.of(context).pushReplacementNamed('/account');
            _isRedirecting = false;
            return;
          }
        } catch (e) {
          print('Web session recovery: $e');
        }
      }
    } catch (e) {
      print('Redirect error: $e');
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    _isRedirecting = false;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading application...'),
          ],
        ),
      ),
    );
  }
}