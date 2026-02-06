import 'package:equatable/equatable.dart';
import 'message_entity.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MessageEntity> messages;

  const ConversationEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, title, createdAt, updatedAt, messages];
}
