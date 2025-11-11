import '../entities/message.dart';

abstract class ChatRepository {
  Future<Message> sendMessage(String userId, String message, List<Message> conversationHistory);
  Future<List<Message>> getMessages(String userId);
  Future<void> saveMessage(Message message);
  Future<void> clearChat(String userId);
  void setUserInfo(String name, int age);
}



