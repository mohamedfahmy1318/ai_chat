import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';
import '../entities/conversation_entity.dart';

abstract class ChatRepository {
  // Remote
  Future<Either<Failure, String>> sendMessage({
    required List<MessageEntity> messages,
  });

  // Local
  Future<Either<Failure, List<ConversationEntity>>> getConversations();

  Future<Either<Failure, ConversationEntity?>> getConversation(String id);

  Future<Either<Failure, void>> saveConversation(
    ConversationEntity conversation,
  );

  Future<Either<Failure, void>> deleteConversation(String id);

  Future<Either<Failure, void>> clearAllConversations();
}
