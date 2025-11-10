import '../../repositories/chat_repository.dart';
import '../../entities/message.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<List<Message>> execute(String userId) async {
    return await repository.getMessages(userId);
  }
}




