import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/features/Services/domain/entities/service_offer_entity.dart';

class ServiceOfferModel extends ServiceOfferEntity {
  const ServiceOfferModel({
    required super.id,
    required super.requestId,
    required super.providerId,
    required super.providerName,
    super.providerImageUrl,
    required super.price,
    required super.description,
    super.isAccepted,
    required super.createdAt,
  });

  factory ServiceOfferModel.fromFirestore(Map<String, dynamic> map, String id) {
    return ServiceOfferModel(
      id: id,
      requestId: map['requestId'] ?? '',
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      providerImageUrl: map['providerImageUrl'],
      price: (map['price'] as num).toDouble(),
      description: map['description'] ?? '',
      isAccepted: map['isAccepted'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'requestId': requestId,
      'providerId': providerId,
      'providerName': providerName,
      'providerImageUrl': providerImageUrl,
      'price': price,
      'description': description,
      'isAccepted': isAccepted,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ServiceOfferModel.fromEntity(ServiceOfferEntity entity) {
    return ServiceOfferModel(
      id: entity.id,
      requestId: entity.requestId,
      providerId: entity.providerId,
      providerName: entity.providerName,
      providerImageUrl: entity.providerImageUrl,
      price: entity.price,
      description: entity.description,
      isAccepted: entity.isAccepted,
      createdAt: entity.createdAt,
    );
  }
}
