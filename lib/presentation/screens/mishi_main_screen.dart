import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/bottom_nav_bar.dart';
import '../providers/mishi_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/providers.dart';
import '../../core/constants/constants.dart';
import 'sala_screen.dart';
import 'comedor_screen.dart';
import 'voz_screen.dart';
import 'dormitorio_screen.dart';

/// Pantalla principal de MishiGPT con navegación por pestañas
class MishiMainScreen extends ConsumerStatefulWidget {
  const MishiMainScreen({super.key});

  @override
  ConsumerState<MishiMainScreen> createState() => _MishiMainScreenState();
}

class _MishiMainScreenState extends ConsumerState<MishiMainScreen> {
  MishiTab _currentTab = MishiTab.sala;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(user?.name ?? 'Amigo'),
              // Contenido según la pestaña
              Expanded(
                child: _buildTabContent(),
              ),
              // Barra de navegación inferior
              MishiBottomNavBar(
                currentTab: _currentTab,
                onTabChanged: (tab) {
                  setState(() {
                    _currentTab = tab;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🐱',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'MishiGPT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '¡Hola, $userName!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Indicadores de estado y botón de logout
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: _buildStatusIndicators(),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  await ref.read(authRepositoryProvider).logout();
                  ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(AppConstants.loginRoute);
                  }
                },
                tooltip: 'Cerrar sesión',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicators() {
    final mishiState = ref.watch(mishiProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StatusIndicator(
          icon: Icons.favorite,
          value: mishiState.happiness,
          color: Colors.red,
        ),
        const SizedBox(width: 4),
        _StatusIndicator(
          icon: Icons.restaurant,
          value: mishiState.hunger,
          color: Colors.orange,
        ),
        const SizedBox(width: 4),
        _StatusIndicator(
          icon: Icons.bedtime,
          value: 100 - mishiState.sleepiness,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_currentTab) {
      case MishiTab.sala:
        return const SalaScreen();
      case MishiTab.comedor:
        return const ComedorScreen();
      case MishiTab.voz:
        return const VozScreen();
      case MishiTab.dormitorio:
        return const DormitorioScreen();
    }
  }
}

class _StatusIndicator extends StatelessWidget {
  final IconData icon;
  final int value;
  final Color color;

  const _StatusIndicator({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 2),
          Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

