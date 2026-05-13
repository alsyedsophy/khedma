import 'package:equatable/equatable.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';

sealed class ConversationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversations;
  ConversationLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

class CreatConversationSuccess extends ConversationState {
  final ConversationEntity conversation;
  CreatConversationSuccess({required this.conversation});
  @override
  List<Object?> get props => [conversation];
}

class CreatConversationError extends ConversationState {
  final String message;
  CreatConversationError({required this.message});
  @override
  List<Object?> get props => [message];
}

class ConversationError extends ConversationState {
  final String message;
  ConversationError({required this.message});
  @override
  List<Object?> get props => [message];
}
