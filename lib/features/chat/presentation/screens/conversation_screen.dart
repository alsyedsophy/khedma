import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Theme/app_colors.dart';
import 'package:khedma/core/Widgets/app_empty_state.dart';
import 'package:khedma/core/Widgets/app_error_widget.dart';
import 'package:khedma/core/Widgets/app_loading.dart';
import 'package:khedma/core/design_system/tokens/app_spacing.dart';
import 'package:khedma/core/di/dependency_injections.dart';
import 'package:khedma/core/extensions/app_extensions.dart';
import 'package:khedma/features/auth/presentation/widgets/logo_and_back.dart';
import 'package:khedma/features/chat/presentation/cubits/conversation/conversation_list_cubit.dart';
import 'package:khedma/features/chat/presentation/cubits/conversation/conversation_list_state.dart';
import 'package:khedma/features/chat/presentation/widgets/conversation_tile.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ConversationListCubit>()..getConversations(),
      child: _ConversationView(),
    );
  }
}

class _ConversationView extends StatelessWidget {
  const _ConversationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.h_24.verticalSpace,
            LogoAndBack(),
            Divider(),
            AppSpacing.h_10.verticalSpace,
            SizedBox(
              child: BlocBuilder<ConversationListCubit, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationLoading ||
                      state is ConversationInitial) {
                    return AppLoading();
                  }
                  if (state is ConversationLoaded) {
                    final conversations = state.conversations;
                    if (conversations.isEmpty) {
                      AppEmptyState(
                        title: "Not Found",
                        subTitle: "Conversation",
                        icon: Icons.hourglass_empty,
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: false,
                      itemBuilder: (context, index) => ConversationTile(),
                      separatorBuilder: (context, index) =>
                          AppSpacing.h_12.verticalSpace,
                      itemCount: 20,
                    );
                  }
                  if (state is ConversationError) {
                    return AppErrorWidget(message: state.message);
                  }
                  return SizedBox();
                },
              ),
            ).expanded,
          ],
        ).paddingHorizontal(AppSpacing.w_24),
      ),
    );
  }
}
