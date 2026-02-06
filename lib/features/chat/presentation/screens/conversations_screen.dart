import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/conversation_tile.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadConversations();
  }

  void _startNewChat() {
    context.read<ChatCubit>().startNewConversation();
    final state = context.read<ChatCubit>().state;
    context.push('${AppRouter.chat}/${state.currentConversation?.id ?? 'new'}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'AI Chat',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(width: 8.w),
            Image.asset(
              'assets/images/logo_app.png',
              color: Theme.of(context).colorScheme.primary,
              width: 20.sp,
              height: 20.sp,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 24.sp),
            onPressed: _startNewChat,
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const LoadingWidget(message: 'Loading conversations...');
          }

          if (state.conversations.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: state.conversations.length,
            separatorBuilder: (_, __) => Divider(height: 1, indent: 72.w),
            itemBuilder: (context, index) {
              final conversation = state.conversations[index];
              return ConversationTile(
                conversation: conversation,
                onTap: () {
                  context.read<ChatCubit>().loadConversation(conversation.id);
                  context.push('${AppRouter.chat}/${conversation.id}');
                },
                onDelete: () {
                  context.read<ChatCubit>().deleteConversation(conversation.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewChat,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start a new chat with Gemini AI',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: _startNewChat,
            icon: const Icon(Icons.add),
            label: const Text('New Chat'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }
}
