import 'package:khedma/features/Subscriptions/domain/entities/plan_entity.dart';

class PlanModel extends PlanEntity {
  const PlanModel({
    required super.id,
    required super.name,
    required super.price,
    required super.currency,
    required super.maxRequests,
    required super.maxOffers,
    super.description,
    super.storeProductIdAndroid,
    super.storeProductIdIos,
  });

  factory PlanModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PlanModel(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'SAR',
      maxRequests: data['maxRequests'] ?? 0,
      maxOffers: data['maxOffers'] ?? 0,
      description: data['description'],
      storeProductIdAndroid: data['storeProductIdAndroid'],
      storeProductIdIos: data['storeProductIdIos'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'maxRequests': maxRequests,
      'maxOffers': maxOffers,
      'description': description,
      'storeProductIdAndroid': storeProductIdAndroid,
      'storeProductIdIos': storeProductIdIos,
    };
  }

  factory PlanModel.fromEntity(PlanEntity entity) {
    return PlanModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      currency: entity.currency,
      maxRequests: entity.maxRequests,
      maxOffers: entity.maxOffers,
      description: entity.description,
      storeProductIdAndroid: entity.storeProductIdAndroid,
      storeProductIdIos: entity.storeProductIdIos,
    );
  }
}
