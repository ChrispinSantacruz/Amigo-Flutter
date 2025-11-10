import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mishi_state.dart';

class MishiNotifier extends StateNotifier<MishiState> {
  MishiNotifier() : super(MishiState());

  /// Alimentar a Mishi
  void feedMishi(String foodType) {
    int hungerIncrease = 0;
    int happinessIncrease = 0;
    String message = '';

    switch (foodType) {
      case 'cat_food':
        hungerIncrease = 25;
        happinessIncrease = 10;
        message = '¡Qué rico! Me encanta la comida de gatos 🐱🍽️';
        break;
      case 'tuna':
        hungerIncrease = 30;
        happinessIncrease = 15;
        message = '¡Mmm! El atún es mi favorito 🐟💕';
        break;
      case 'fish':
        hungerIncrease = 20;
        happinessIncrease = 12;
        message = '¡Ronroneo! Este pescado está delicioso 🐠✨';
        break;
    }

    final newHunger = (state.hunger + hungerIncrease).clamp(0, 100);
    final newHappiness = (state.happiness + happinessIncrease).clamp(0, 100);

    state = state.copyWith(
      hunger: newHunger,
      happiness: newHappiness,
      isEating: true,
      currentActionMessage: message,
      lastActionTime: DateTime.now(),
    );

    // Después de 2 segundos, dejar de comer
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        state = state.copyWith(
          isEating: false,
          clearActionMessage: true,
        );
      }
    });
  }

  /// Hacer que Mishi ronronee
  void purr() {
    state = state.copyWith(
      happiness: (state.happiness + 5).clamp(0, 100),
      currentActionMessage: '¡Purr purr purr! 🐱💕\nMe siento tan feliz contigo',
      lastActionTime: DateTime.now(),
    );

    // Limpiar mensaje después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        state = state.copyWith(clearActionMessage: true);
      }
    });
  }

  /// Dormir/Despertar a Mishi
  void toggleSleep() {
    if (state.isSleeping) {
      // Despertar
      state = state.copyWith(
        isSleeping: false,
        sleepiness: state.sleepiness - 30,
        currentActionMessage: '¡Miau! ¡Buenos días! 🐱☀️\nEstoy listo para jugar',
        lastActionTime: DateTime.now(),
      );
    } else {
      // Dormir
      state = state.copyWith(
        isSleeping: true,
        sleepiness: 100,
        currentActionMessage: 'Zzzzzz... 💤\nMishi está soñando con aventuras mágicas',
        lastActionTime: DateTime.now(),
      );
    }

    // Limpiar mensaje después de 3 segundos (solo si está despierto)
    if (!state.isSleeping) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          state = state.copyWith(clearActionMessage: true);
        }
      });
    }
  }

  /// Actualizar estados automáticamente (se puede llamar periódicamente)
  void updateStates() {
    // La hambre disminuye con el tiempo
    final newHunger = (state.hunger - 1).clamp(0, 100);
    // El sueño aumenta con el tiempo si no está durmiendo
    final newSleepiness = state.isSleeping
        ? state.sleepiness
        : (state.sleepiness + 1).clamp(0, 100);

    state = state.copyWith(
      hunger: newHunger,
      sleepiness: newSleepiness,
    );
  }
}

final mishiProvider = StateNotifierProvider<MishiNotifier, MishiState>((ref) {
  return MishiNotifier();
});

