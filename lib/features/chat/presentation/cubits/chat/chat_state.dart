import 'package:equatable/equatable.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';

sealed class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageEntity> messages; // للحفاظ على الرسائل محلياً

  ChatLoaded({required this.messages});
  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

class MessageSending extends ChatState {}

class MessageSentSuccess extends ChatState {}

class MessageSendError extends ChatState {
  final String message;
  MessageSendError(this.message);
  @override
  List<Object?> get props => [message];
}
