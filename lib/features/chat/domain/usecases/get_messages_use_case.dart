import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';

import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;
  GetMessagesUseCase(this.repository);
  Future<Either<Failure, Stream<List<MessageEntity>>>> call(
    String conversationId,
  ) async {
    return await repository.getMessages(conversationId);
  }
}
