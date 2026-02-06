import 'package:hive/hive.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.text,
    required this.role,
    required this.timestamp,
  });

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      text: entity.text,
      role: entity.role == MessageRole.user ? 'user' : 'model',
      timestamp: entity.timestamp,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      text: text,
      role: role == 'user' ? MessageRole.user : MessageRole.model,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toApiFormat() {
    return {
      'role': role,
      'parts': [
        {'text': text},
      ],
    };
  }
}
