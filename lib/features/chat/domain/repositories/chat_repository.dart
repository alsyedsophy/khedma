import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, ConversationEntity>> createConversation(
    ConversationEntity conversation,
  );
  Future<Either<Failure, MessageEntity>> sendMessage(
    String conversationId,
    MessageEntity message,
  );
  Future<Either<Failure, Stream<List<ConversationEntity>>>> getConversations(
    String userId,
  );
  Future<Either<Failure, Stream<List<MessageEntity>>>> getMessages(
    String conversationId,
  );
  Future<Either<Failure, String>> uploadChatImage(
    String fileName,
    String filePath,
  );
}
