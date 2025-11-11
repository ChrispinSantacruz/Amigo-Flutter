import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/mishi_state.dart';

/// Widget del personaje Mishi con animaciones
class MishiCharacter extends StatelessWidget {
  final MishiState state;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MishiCharacter({
    super.key,
    required this.state,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 150,
          maxHeight: 150,
          minWidth: 120,
          minHeight: 120,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Mishi durmiendo
            if (state.isSleeping)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '😴',
                    style: TextStyle(fontSize: 100),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Zzzzzz...',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            // Mishi comiendo
            else if (state.isEating)
              const Text(
                '🐱🍽️',
                style: TextStyle(fontSize: 100),
              )
                .animate(onPlay: (controller) => controller.repeat())
                .shake(duration: 500.ms, hz: 4)
            // Mishi normal
            else
              const Text(
                '🐱',
                style: TextStyle(fontSize: 100),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.1, 1.1),
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.1, 1.1),
                    end: const Offset(1.0, 1.0),
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  ),
          ],
        ),
      ),
    );
  }
}

