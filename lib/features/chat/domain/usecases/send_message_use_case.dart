import 'package:dartz/dartz.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);
  Future<Either<Failure, MessageEntity>> call(
    String conversationId,
    MessageEntity message,
  ) async {
    return await repository.sendMessage(conversationId, message);
  }
}
