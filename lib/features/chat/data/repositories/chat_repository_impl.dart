import 'package:dartz/dartz.dart';
import 'package:khedma/core/network/network_info.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ConversationEntity>> createConversation(
    ConversationEntity conversation,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final model = ConversationModel.fromEntity(conversation);
      final result = await remoteDataSource.createConversation(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('تعذر إنشاء المحادثة'));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
    String conversationId,
    MessageEntity message,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final model = MessageModel.fromEntity(message);
      final result = await remoteDataSource.sendMessage(conversationId, model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('تعذر إرسال الرسالة'));
    }
  }

  @override
  Future<Either<Failure, Stream<List<ConversationEntity>>>>
  getConversations() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final stream = remoteDataSource.getConversations();
      // .map(
      //   (list) => list.map((e) => e as ConversationEntity).toList(),
      // ).handleError((error) {
      //   if (error is ServerException) {
      //     throw error;
      //   }
      //   throw ServerException(message: error.toString());
      // });
      return Right(stream);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Stream<List<MessageModel>>>> getMessages(
    String conversationId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final stream = remoteDataSource.getMessages(conversationId);
      return Right(stream);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadChatImage(
    String fileName,
    String filePath,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }
    try {
      final url = await remoteDataSource.uploadChatImage(fileName, filePath);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure('تعذر رفع الصورة'));
    }
  }
}
