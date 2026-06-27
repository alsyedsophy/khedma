import 'package:khedma/features/Subscriptions/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.planId,
    required super.purchaseDate,
    required super.remainingCredits,
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
      remainingCredits: data['remainingCredits'] ?? 0,
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'planId': planId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'remainingCredits': remainingCredits,
      'isActive': isActive,
    };
  }

  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      id: entity.id,
      planId: entity.planId,
      purchaseDate: entity.purchaseDate,
      remainingCredits: entity.remainingCredits,
      isActive: entity.isActive,
    );
  }
}
