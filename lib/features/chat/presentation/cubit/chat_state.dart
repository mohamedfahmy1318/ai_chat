import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ConversationEntity> conversations,
    ConversationEntity? currentConversation,
    @Default([]) List<MessageEntity> messages,
    @Default(false) bool isLoading,
    @Default(false) bool isSending,
    String? error,
  }) = _ChatState;
}
