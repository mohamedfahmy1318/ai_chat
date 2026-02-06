import 'package:ai_chat_app/features/chat/presentation/widgets/welcome_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String? conversationId;

  const ChatScreen({super.key, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.conversationId != null && widget.conversationId != 'new') {
      context.read<ChatCubit>().loadConversation(widget.conversationId!);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Text(
              state.currentConversation?.title ?? 'New Chat',
              style: TextStyle(fontSize: 16.sp),
            );
          },
        ),
      ),

      body: Column(
        children: [
          // Messages list
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                _scrollToBottom();
              },
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return const WelcomeMessage();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 16.h,
                  ),
                  itemCount: state.messages.length + (state.isSending ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.messages.length && state.isSending) {
                      return const TypingIndicator();
                    }
                    return MessageBubble(message: state.messages[index]);
                  },
                );
              },
            ),
          ),

          // Input area
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return ChatInput(
                onSend: (text) {
                  context.read<ChatCubit>().sendMessage(text);
                },
                isLoading: state.isSending,
              );
            },
          ),
        ],
      ),
    );
  }
}
