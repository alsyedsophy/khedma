import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/features/chat/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.participants,
    required super.requestId,
    super.lastMessage,
    super.lastMessageTime,
  });

  factory ConversationModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return ConversationModel(
      id: id,
      participants: List<String>.from(data['participants'] ?? []),
      requestId: data['requestId'] ?? '',
      lastMessage: data['lastMessage'],
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'requestId': requestId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory ConversationModel.fromEntity(ConversationEntity entity) {
    return ConversationModel(
      id: entity.id,
      participants: entity.participants,
      requestId: entity.requestId,
      lastMessage: entity.lastMessage,
      lastMessageTime: entity.lastMessageTime,
    );
  }
}
