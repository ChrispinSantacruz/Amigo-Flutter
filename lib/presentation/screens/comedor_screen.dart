import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/mishi_character.dart';
import '../widgets/action_bubble.dart';
import '../providers/mishi_provider.dart';

/// Pantalla del Comedor - Alimentar a Mishi
class ComedorScreen extends ConsumerWidget {
  const ComedorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mishiState = ref.watch(mishiProvider);

    return Column(
      children: [
        // ÁREA FIJA: MishiGPT + Burbujas de acción (SIN SCROLL)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mishi Character (siempre visible, sin scroll)
              MishiCharacter(state: mishiState),
              // Burbuja de acción si existe (siempre visible)
              if (mishiState.currentActionMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ActionBubble(
                    message: mishiState.currentActionMessage!,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    '¡Toca la comida para alimentarme! 🍽️',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        // ÁREA FIJA: Indicadores de estado (SIN SCROLL)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _buildStatusIndicators(mishiState),
        ),
        
        // ÁREA CON SCROLL: Opciones de comida
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '¿Qué quieres darle de comer a Mishi? 🍽️',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: _FoodButton(
                          icon: '🐱',
                          label: 'Comida\nde Gatos',
                          color: const Color(0xFFFF6B35),
                          onTap: () {
                            ref.read(mishiProvider.notifier).feedMishi('cat_food');
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _FoodButton(
                          icon: '🐟',
                          label: 'Atún',
                          color: const Color(0xFF4ECDC4),
                          onTap: () {
                            ref.read(mishiProvider.notifier).feedMishi('tuna');
                          },
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _FoodButton(
                          icon: '🐠',
                          label: 'Pescado',
                          color: const Color(0xFF45B7D1),
                          onTap: () {
                            ref.read(mishiProvider.notifier).feedMishi('fish');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicators(mishiState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatusItem(
          icon: Icons.favorite,
          label: 'Felicidad',
          value: mishiState.happiness,
          color: Colors.red,
        ),
        _StatusItem(
          icon: Icons.restaurant,
          label: 'Hambre',
          value: mishiState.hunger,
          color: Colors.orange,
        ),
      ],
    );
  }
}

class _FoodButton extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FoodButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 70,
          maxWidth: 90,
          minHeight: 90,
          maxHeight: 100,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

