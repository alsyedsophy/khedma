import 'package:khedma/core/errors/extentions.dart';

import '../models/message_model.dart';
import '../models/conversation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

abstract class ChatRemoteDataSource {
  // إنشاء محادثة جديدة (بعد قبول العرض)
  Future<ConversationModel> createConversation(ConversationModel conversation);
  // إرسال رسالة
  Future<MessageModel> sendMessage(String conversationId, MessageModel message);
  // جلب قائمة المحادثات الخاصة بمستخدم
  Stream<List<ConversationModel>> getConversations(String userId);
  // جلب رسائل محادثة معينة
  Stream<List<MessageModel>> getMessages(String conversationId);
  // رفع صورة للمحادثة
  Future<String> uploadChatImage(String fileName, String filePath);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ChatRemoteDataSourceImpl(
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  ) : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  CollectionReference get _chatCollection => _firestore.collection('Chats');
  CollectionReference _messagesCollection(String docId) =>
      _firestore.collection('chats').doc(docId).collection('Messages');

  @override
  Future<ConversationModel> createConversation(
    ConversationModel conversation,
  ) async {
    try {
      final docRef = _chatCollection.doc();
      final newConversation = ConversationModel(
        id: docRef.id,
        participants: conversation.participants,
        requestId: conversation.requestId,
        lastMessage: conversation.lastMessage,
        lastMessageTime: DateTime.now(),
      );
      await docRef.set(newConversation.toFirestore());
      return newConversation;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessage(
    String conversationId,
    MessageModel message,
  ) async {
    try {
      final docRef = _messagesCollection(conversationId).doc();
      final chatRef = _chatCollection.doc(conversationId);
      final newMessage = MessageModel(
        id: docRef.id,
        senderId: message.senderId,
        text: message.text,
        timestamp: message.timestamp,
        imageUrl: message.imageUrl,
      );
      final data = {
        'lastMessage': message.text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      };
      final batch = _firestore.batch();
      batch.set(docRef, newMessage.toFirestore());
      batch.update(chatRef, data);
      await batch.commit();
      return newMessage;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<ConversationModel>> getConversations(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ConversationModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        )
        .handleError((error) {
          throw ServerException(message: error.toString());
        });
  }

  @override
  Stream<List<MessageModel>> getMessages(String conversationId) {
    return _messagesCollection(conversationId)
        .orderBy(
          'timestamp',
          descending: true,
        ) // غيرتها إلى true (الأحدث أولاً)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => MessageModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();
        })
        .handleError((error) {
          throw ServerException(message: error.toString());
        });
  }

  @override
  Future<String> uploadChatImage(String fileName, String filePath) async {
    try {
      final ref = _storage.ref().child('chat_images/$fileName');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
