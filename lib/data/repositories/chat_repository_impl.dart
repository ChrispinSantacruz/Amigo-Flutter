import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:uuid/uuid.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../services/ai_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SupabaseClient _supabase;
  final AIService _aiService;
  String? _currentUserName;
  int? _currentUserAge;

  ChatRepositoryImpl(this._supabase, this._aiService);

  void setUserInfo(String name, int age) {
    _currentUserName = name;
    _currentUserAge = age;
  }

  @override
  Future<Message> sendMessage(
    String userId,
    String message,
    List<Message> conversationHistory,
  ) async {
    try {
      final uuid = const Uuid();
      
      // Guardar mensaje del usuario en Supabase
      final userMessage = Message(
        id: uuid.v4(),
        userId: userId,
        text: message,
        isFromUser: true,
        createdAt: DateTime.now(),
      );
      await saveMessage(userMessage);

      // Convertir el historial de conversación al formato esperado por la IA
      // Incluir todos los mensajes previos + el mensaje del usuario que acabamos de guardar
      final allMessages = [...conversationHistory, userMessage];
      
      final historyForAI = allMessages.map((msg) {
        return {
          'role': msg.isFromUser ? 'user' : 'assistant',
          'content': msg.text,
        };
      }).toList();

      // Obtener respuesta de la IA con el contexto completo (incluyendo el nuevo mensaje)
      final aiResponse = await _aiService.getResponse(
        message,
        _currentUserName ?? 'Amigo',
        _currentUserAge ?? 8,
        historyForAI,
      );

      // Guardar respuesta de la IA en Supabase
      final aiMessage = Message(
        id: uuid.v4(),
        userId: userId,
        text: aiResponse,
        isFromUser: false,
        createdAt: DateTime.now(),
      );
      await saveMessage(aiMessage);

      return aiMessage;
    } catch (e) {
      throw Exception('Error al enviar mensaje: $e');
    }
  }

  @override
  Future<List<Message>> getMessages(String userId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => Message.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mensajes: $e');
    }
  }

  @override
  Future<void> saveMessage(Message message) async {
    try {
      await _supabase.from('messages').insert({
        'id': message.id,
        'user_id': message.userId,
        'message': message.text,
        'is_from_user': message.isFromUser,
        'created_at': message.createdAt.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al guardar mensaje en Supabase: $e');
    }
  }

  @override
  Future<void> clearChat(String userId) async {
    try {
      await _supabase
          .from('messages')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al limpiar el chat: $e');
    }
  }
}

