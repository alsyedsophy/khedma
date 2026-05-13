import 'package:khedma/features/Subscriptions/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.planId,
    required super.purchaseDate,
    required super.remainingRequests,
    required super.remainingOffers,
    required super.isActive,
  });

  factory SubscriptionModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return SubscriptionModel(
      id: id,
      planId: data['planId'] ?? '',
      purchaseDate: DateTime.parse(
        data['purchaseDate'] ?? DateTime.now().toIso8601String(),
      ),
      remainingRequests: data['remainingRequests'] ?? 0,
      remainingOffers: data['remainingOffers'] ?? 0,
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'planId': planId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'remainingRequests': remainingRequests,
      'remainingOffers': remainingOffers,
      'isActive': isActive,
    };
  }

  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      id: entity.id,
      planId: entity.planId,
      purchaseDate: entity.purchaseDate,
      remainingRequests: entity.remainingRequests,
      remainingOffers: entity.remainingOffers,
      isActive: entity.isActive,
    );
  }
}
