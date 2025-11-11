/// Estado del gatito Mishi
class MishiState {
  final int hunger; // 0-100 (0 = muy hambriento, 100 = lleno)
  final int sleepiness; // 0-100 (0 = muy despierto, 100 = muy cansado)
  final int happiness; // 0-100 (0 = triste, 100 = muy feliz)
  final bool isSleeping;
  final bool isEating;
  final String? currentActionMessage; // Mensaje de acción actual (comer, ronronear, etc.)
  final DateTime lastActionTime;

  MishiState({
    this.hunger = 50,
    this.sleepiness = 50,
    this.happiness = 75,
    this.isSleeping = false,
    this.isEating = false,
    this.currentActionMessage,
    DateTime? lastActionTime,
  }) : lastActionTime = lastActionTime ?? DateTime(2024, 1, 1);

  MishiState copyWith({
    int? hunger,
    int? sleepiness,
    int? happiness,
    bool? isSleeping,
    bool? isEating,
    String? currentActionMessage,
    DateTime? lastActionTime,
    bool clearActionMessage = false,
  }) {
    return MishiState(
      hunger: hunger ?? this.hunger,
      sleepiness: sleepiness ?? this.sleepiness,
      happiness: happiness ?? this.happiness,
      isSleeping: isSleeping ?? this.isSleeping,
      isEating: isEating ?? this.isEating,
      currentActionMessage: clearActionMessage
          ? null
          : (currentActionMessage ?? this.currentActionMessage),
      lastActionTime: lastActionTime ?? this.lastActionTime,
    );
  }
}

