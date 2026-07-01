import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';

import '../repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository repository;
  GetConversationsUseCase(this.repository);
  Future<Either<Failure, Stream<List<ConversationEntity>>>> call() async {
    return await repository.getConversations();
  }
}
