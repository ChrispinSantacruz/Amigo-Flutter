import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/get_messages_usecase.dart';
import 'providers.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final sendMessageUseCase = ref.watch(sendMessageUseCaseProvider);
  final getMessagesUseCase = ref.watch(getMessagesUseCaseProvider);
  return ChatNotifier(sendMessageUseCase, getMessagesUseCase);
});

class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  String? _currentUserId;

  ChatNotifier(this._sendMessageUseCase, this._getMessagesUseCase)
      : super(ChatState());

  void setUserId(String userId) {
    _currentUserId = userId;
    loadMessages();
  }

  Future<void> loadMessages() async {
    if (_currentUserId == null) return;
    
    state = state.copyWith(isLoading: true);
    try {
      final messages = await _getMessagesUseCase.execute(_currentUserId!);
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String message) async {
    if (_currentUserId == null || message.trim().isEmpty) return;

    // Mostrar estado de carga
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Pasar el historial completo actual
      final conversationHistory = state.messages;
      
      // El repositorio guardará el mensaje del usuario, obtendrá la respuesta de la IA
      // con el contexto completo, y guardará la respuesta
      await _sendMessageUseCase.execute(
        _currentUserId!,
        message,
        conversationHistory,
      );
      
      // Recargar todos los mensajes desde Supabase para asegurar sincronización
      await loadMessages();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

