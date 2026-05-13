import 'package:dartz/dartz.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class CreateConversationUseCase {
  final ChatRepository repository;
  CreateConversationUseCase(this.repository);
  Future<Either<Failure, ConversationEntity>> call(
    ConversationEntity conversation,
  ) async {
    return await repository.createConversation(conversation);
  }
}
