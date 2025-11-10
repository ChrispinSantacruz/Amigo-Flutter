import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/providers.dart';
import '../../core/constants/constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    try {
      final authRepository = ref.read(authRepositoryProvider);
      final isLoggedIn = await authRepository.isLoggedIn();
      
      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        if (user != null && mounted) {
          // Actualizar el estado del provider
          ref.read(authProvider.notifier).setUser(user);
          Navigator.of(context).pushReplacementNamed(AppConstants.homeRoute);
          return;
        }
      }
    } catch (e) {
      // Error al verificar autenticación
    }
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFB6C1),
              Color(0xFFFFC0CB),
              Color(0xFFFFD700),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🐱',
                style: TextStyle(fontSize: 100),
              ),
              const SizedBox(height: 20),
              Text(
                '¡Miau!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu gatito virtual te espera',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

