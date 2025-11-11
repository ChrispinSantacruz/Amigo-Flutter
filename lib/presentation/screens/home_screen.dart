import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/chat_provider.dart';
import '../../presentation/providers/providers.dart';
import 'mishi_main_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ref.read(chatProvider.notifier).setUserId(authState.user!.id);
        // Configurar información del usuario en el repositorio de chat
        final chatRepo = ref.read(chatRepositoryProvider);
        chatRepo.setUserInfo(authState.user!.name, authState.user!.age);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Redirigir a la pantalla principal de MishiGPT
    return const MishiMainScreen();
  }
}



