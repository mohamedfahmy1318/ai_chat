import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/delete_conversation_usecase.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/save_conversation_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase sendMessageUseCase;
  final GetConversationsUseCase getConversationsUseCase;
  final SaveConversationUseCase saveConversationUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;

  final _uuid = const Uuid();

  ChatCubit({
    required this.sendMessageUseCase,
    required this.getConversationsUseCase,
    required this.saveConversationUseCase,
    required this.deleteConversationUseCase,
  }) : super(const ChatState());

  // Load all conversations
  Future<void> loadConversations() async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getConversationsUseCase();

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (conversations) =>
          emit(state.copyWith(isLoading: false, conversations: conversations)),
    );
  }

  // Start new conversation
  void startNewConversation() {
    final newConversation = ConversationEntity(
      id: _uuid.v4(),
      title: 'New Chat',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: [],
    );

    emit(state.copyWith(currentConversation: newConversation, messages: []));
  }

  // Load existing conversation
  Future<void> loadConversation(String id) async {
    final conversation = state.conversations.firstWhere(
      (c) => c.id == id,
      orElse: () => ConversationEntity(
        id: id,
        title: 'New Chat',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        messages: [],
      ),
    );

    emit(
      state.copyWith(
        currentConversation: conversation,
        messages: conversation.messages,
      ),
    );
  }

  // Send message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    emit(state.copyWith(isSending: true, error: null));

    // Create user message
    final userMessage = MessageEntity(
      id: _uuid.v4(),
      text: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    // إضافة الرسالة للشاشة
    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(messages: updatedMessages));

    // Send to API
    final result = await sendMessageUseCase(messages: updatedMessages);

    result.fold(
      (failure) {
        emit(state.copyWith(isSending: false, error: failure.message));
      },
      (response) async {
        // Create model response
        final modelMessage = MessageEntity(
          id: _uuid.v4(),
          text: response,
          role: MessageRole.model,
          timestamp: DateTime.now(),
        );

        final allMessages = [...updatedMessages, modelMessage];

        // Update conversation
        final title =
            state.currentConversation?.title == 'New Chat' && text.isNotEmpty
            ? text.length > 30
                  ? '${text.substring(0, 30)}...'
                  : text
            : state.currentConversation?.title ?? 'New Chat';

        final updatedConversation = ConversationEntity(
          id: state.currentConversation?.id ?? _uuid.v4(),
          title: title,
          createdAt: state.currentConversation?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          messages: allMessages,
        );

        // Save conversation
        await saveConversationUseCase(updatedConversation);

        // Update state
        emit(
          state.copyWith(
            isSending: false,
            messages: allMessages,
            currentConversation: updatedConversation,
          ),
        );

        // Refresh conversations list
        await loadConversations();
      },
    );
  }

  // Delete conversation
  Future<void> deleteConversation(String id) async {
    await deleteConversationUseCase(id);
    await loadConversations();

    if (state.currentConversation?.id == id) {
      emit(state.copyWith(currentConversation: null, messages: []));
    }
  }
}
