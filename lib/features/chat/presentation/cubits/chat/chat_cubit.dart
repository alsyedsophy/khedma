import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';
import 'package:khedma/features/chat/domain/usecases/get_messages_use_case.dart';
import 'package:khedma/features/chat/domain/usecases/send_message_use_case.dart';
import 'package:khedma/features/chat/presentation/cubits/chat/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial());

  // ====================== جلب الرسائل ======================
  Future<void> getMessages(String conversationId) async {
    emit(ChatLoading());

    final result = await getMessagesUseCase(conversationId);

    result.fold((failure) => emit(ChatError(failure.message)), (stream) {
      _messagesSubscription?.cancel();
      _messagesSubscription = stream.listen(
        (messages) {
          emit(ChatLoaded(messages: messages));
        },
        onError: (error) {
          emit(ChatError(error.toString()));
        },
      );
    });
  }

  // ====================== إرسال رسالة ======================
  Future<void> sendMessage({
    required String conversationId,
    required MessageEntity message,
  }) async {
    emit(MessageSending());

    final result = await sendMessageUseCase(conversationId, message);

    result.fold((failure) => emit(MessageSendError(failure.message)), (
      sentMessage,
    ) {
      emit(MessageSentSuccess());
    });
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
