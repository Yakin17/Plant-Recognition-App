import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:plantrecognition_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null && mounted) {
        _checkAndRedirectUser(session.user.id, session.user.email!);
      }
    });
  }

  Future<void> _checkAndRedirectUser(String userId, String email) async {
    try {
      // Toujours assurer que l'email est sauvegardé pour ce user (nouveau ou existant)
      await supabase.from('profiles').upsert({
        'id': userId,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Aller au compte (l'utilisateur pourra compléter le profil)
      Navigator.of(context).pushReplacementNamed('/account');
    } catch (e) {
      // En cas d'erreur, rediriger vers account_page par défaut
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/account');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  Future<void> _signInWithMagicLink() async {
    if (_loading || !_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    
    try {
      final email = _emailController.text.trim();
      
      // Envoyer le lien magique (Supabase créera automatiquement l'utilisateur dans Auth)
      await supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Check your email for the login link'),
          ),
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending login link: $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'New here?',
                  style: TextStyle(
                    color: Color(0xFF6C757D),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // Navigate to sign up page
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xFF007BFF),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email*',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212529),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Judy.mobbin@gmail.com',
                      hintStyle: const TextStyle(color: Color(0xFF6C757D)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFCED4DA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFCED4DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF007BFF)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signInWithMagicLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Send Magic Link'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                   
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}