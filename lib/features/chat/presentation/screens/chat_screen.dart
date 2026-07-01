import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Widgets/app_error_widget.dart';
import 'package:khedma/core/Widgets/app_loading.dart';
import 'package:khedma/core/constants/app_assets.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/design_system/tokens/app_typography.dart';
import 'package:khedma/core/di/dependency_injections.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/chat/domain/entities/message_entity.dart';
import 'package:khedma/features/chat/presentation/cubits/chat/chat_cubit.dart';
import 'package:khedma/features/chat/presentation/cubits/chat/chat_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatCubit>()..getMessages("conversationId"),
      child: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  const _ChatView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
        actions: [
          Row(
            children: [
              Text('Name', style: AppTypography.headlineSmall),
              AppSpacing.w_24.horizontalSpace,
              CircleAvatar(
                radius: AppSpacing.r_16,
                backgroundImage: AssetImage(AppAssets.woman),
              ),
            ],
          ),
          AppSpacing.w_24.horizontalSpace,
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatInitial || state is ChatLoading) {
            return AppLoading();
          }
          if (state is ChatError) {
            return AppErrorWidget(message: 'Error is found');
          }
          if (state is ChatLoaded) {
            final messages = state.messages;
            return ListView.separated(
              reverse: true,
              itemBuilder: (context, index) => Text('data'),
              separatorBuilder: (_, _) => AppSpacing.h_8.verticalSpace,
              itemCount: messages.length,
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().state.user;
    final isMe = message.senderId == currentUser!.id;
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: AppSpacing.h_12.allPadding,
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.w_12,
          vertical: AppSpacing.h_4,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryLight : AppColors.info,
          borderRadius: AppSpacing.r_16.borderRaduis,
        ),
        child: Text(message.text),
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(child: TextField(controller: _controller)),
          IconButton(
            onPressed: () {
              context.read<ChatCubit>().sendMessage(
                conversationId: "conversationId",
                message: MessageEntity(
                  id: "",
                  senderId: "",
                  text: _controller.text,
                  timestamp: DateTime.now(),
                ),
              );
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
