import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class SaveConversationUseCase {
  final ChatRepository repository;

  SaveConversationUseCase(this.repository);

  Future<Either<Failure, void>> call(ConversationEntity conversation) async {
    return await repository.saveConversation(conversation);
  }
}
