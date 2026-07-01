import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';
import 'package:khedma/features/chat/domain/usecases/create_conversation_use_case.dart';
import 'package:khedma/features/chat/domain/usecases/get_conversations_use_case.dart';
import 'conversation_list_state.dart';

class ConversationListCubit extends Cubit<ConversationState> {
  final GetConversationsUseCase getConversationsUseCase;
  final CreateConversationUseCase createConversationUseCase;
  StreamSubscription<List<ConversationEntity>>? _sub;

  ConversationListCubit({
    required this.getConversationsUseCase,
    required this.createConversationUseCase,
  }) : super(ConversationInitial());

  Future<void> getConversations() async {
    emit(ConversationLoading());

    final result = await getConversationsUseCase();

    result.fold(
      (failure) => emit(ConversationError(message: failure.message)),
      (stream) {
        _sub?.cancel();
        _sub = stream.listen(
          (conversations) {
            emit(ConversationLoaded(conversations: conversations));
          },
          onError: (error) {
            emit(ConversationError(message: error.toString()));
          },
        );
      },
    );
  }

  Future<void> creatConversation(ConversationEntity conversation) async {
    emit(ConversationLoading());
    final result = await createConversationUseCase(conversation);
    result.fold(
      (failure) => emit(CreatConversationError(message: failure.message)),
      (conversation) =>
          emit(CreatConversationSuccess(conversation: conversation)),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
