import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/conversation_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel?> getConversation(String id);
  Future<void> saveConversation(ConversationModel conversation);
  Future<void> deleteConversation(String id);
  Future<void> clearAllConversations();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Box<ConversationModel> conversationsBox;

  ChatLocalDataSourceImpl({required this.conversationsBox});

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final conversations = conversationsBox.values.toList();
      conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return conversations;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<ConversationModel?> getConversation(String id) async {
    try {
      return conversationsBox.get(id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> saveConversation(ConversationModel conversation) async {
    try {
      await conversationsBox.put(conversation.id, conversation);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> deleteConversation(String id) async {
    try {
      await conversationsBox.delete(id);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> clearAllConversations() async {
    try {
      await conversationsBox.clear();
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
