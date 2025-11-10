import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/mishi_character.dart';
import '../widgets/action_bubble.dart';
import '../providers/mishi_provider.dart';

/// Pantalla del Dormitorio - Dormir/Despertar a Mishi
class DormitorioScreen extends ConsumerWidget {
  const DormitorioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mishiState = ref.watch(mishiProvider);

    return Stack(
      children: [
        // Fondo con efecto de luz/apagado
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: mishiState.isSleeping
                  ? [
                      const Color(0xFF1a1a2e),
                      const Color(0xFF16213e),
                      const Color(0xFF0f3460),
                    ]
                  : [
                      const Color(0xFFFFF5E1),
                      const Color(0xFFFFE5B4),
                      const Color(0xFFFFD89B),
                    ],
            ),
          ),
        ),
        // Contenido
        Column(
          children: [
            // ÁREA FIJA: MishiGPT + Burbujas de acción (SIN SCROLL)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mishiState.isSleeping
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
                  else if (mishiState.isSleeping)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Zzzzzz... 💤',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: mishiState.isSleeping ? Colors.white : const Color(0xFF666666),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Mishi está despierto y listo para jugar! 🐱☀️',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: mishiState.isSleeping ? Colors.white : const Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // ÁREA FIJA: Indicador de sueño (SIN SCROLL)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mishiState.isSleeping
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildSleepIndicator(mishiState),
            ),
            
            // ÁREA CON SCROLL: Interruptor de luz
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: mishiState.isSleeping
                        ? Colors.white.withOpacity(0.2)
                        : Colors.white.withOpacity(0.9),
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
                      Text(
                        '💡 Interruptor de Luz',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mishiState.isSleeping ? Colors.white : const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _LightSwitch(
                        isOn: !mishiState.isSleeping,
                        onToggle: () {
                          ref.read(mishiProvider.notifier).toggleSleep();
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mishiState.isSleeping
                            ? 'Luz apagada - Mishi está durmiendo 💤'
                            : 'Luz encendida - Mishi está despierto ☀️',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: mishiState.isSleeping ? Colors.white : const Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSleepIndicator(mishiState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.bedtime,
          color: mishiState.isSleeping ? Colors.white : Colors.blue,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'Sueño: ${100 - mishiState.sleepiness}%',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: mishiState.isSleeping ? Colors.white : Colors.blue,
          ),
        ),
      ],
    );
  }
}

class _LightSwitch extends StatelessWidget {
  final bool isOn;
  final VoidCallback onToggle;

  const _LightSwitch({
    required this.isOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: isOn ? const Color(0xFFFFD700) : const Color(0xFF333333),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: (isOn ? Colors.orange : Colors.black).withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isOn ? 50 : 10,
              top: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isOn ? Icons.wb_sunny : Icons.nightlight_round,
                  color: isOn ? Colors.orange : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

