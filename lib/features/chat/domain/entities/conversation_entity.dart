import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<String> participants; // [userId1, userId2]
  final String requestId; // مرتبطة بطلب الخدمة
  final String? lastMessage;
  final DateTime? lastMessageTime;

  const ConversationEntity({
    required this.id,
    required this.participants,
    required this.requestId,
    this.lastMessage,
    this.lastMessageTime,
  });

  ConversationEntity copyWith({
    String? id,
    List<String>? participants,
    String? requestId,
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      requestId: requestId ?? this.requestId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }

  @override
  List<Object?> get props => [
    id,
    participants,
    requestId,
    lastMessage,
    lastMessageTime,
  ];
}
