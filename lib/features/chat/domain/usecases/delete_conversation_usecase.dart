import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/chat_repository.dart';

class DeleteConversationUseCase {
  final ChatRepository repository;

  DeleteConversationUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteConversation(id);
  }
}
