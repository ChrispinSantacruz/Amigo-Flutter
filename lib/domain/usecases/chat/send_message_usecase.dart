import '../../repositories/chat_repository.dart';
import '../../entities/message.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Message> execute(
    String userId,
    String message,
    List<Message> conversationHistory,
  ) async {
    if (message.trim().isEmpty) {
      throw Exception('El mensaje no puede estar vacío');
    }
    return await repository.sendMessage(userId, message, conversationHistory);
  }
}



