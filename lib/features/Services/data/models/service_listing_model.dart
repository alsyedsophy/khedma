import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/entities/service_listing_entity.dart';

class ServiceListingModel extends ServiceListingEntity {
  const ServiceListingModel({
    required super.id,
    required super.providerId,
    required super.providerName,
    super.providerImageUrl,
    required super.title,
    required super.description,
    required super.categoryId,
    required super.category,
    required super.price,
    required super.city,
    required super.governorate,
    super.isAvailable,
    required super.createdAt,
  });

  factory ServiceListingModel.fromFirestore(
    Map<String, dynamic> map,
    String id,
  ) {
    return ServiceListingModel(
      id: id,
      providerId: map['providerId'] ?? '',
      providerName: map['providerName'] ?? '',
      providerImageUrl: map['providerImageUrl'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      category: _categoryFromString(map['category']),
      price: (map['price'] as num).toDouble(),
      city: map['city'] ?? '',
      governorate: map['governorate'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'providerId': providerId,
      'providerName': providerName,
      'providerImageUrl': providerImageUrl,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'category': category.toString().split('.').last,
      'price': price,
      'city': city,
      'governorate': governorate,
      'isAvailable': isAvailable,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory ServiceListingModel.fromEntity(ServiceListingEntity entity) {
    return ServiceListingModel(
      id: entity.id,
      providerId: entity.providerId,
      providerName: entity.providerName,
      providerImageUrl: entity.providerImageUrl,
      title: entity.title,
      description: entity.description,
      categoryId: entity.categoryId,
      category: entity.category,
      price: entity.price,
      city: entity.city,
      governorate: entity.governorate,
      isAvailable: entity.isAvailable,
      createdAt: entity.createdAt,
    );
  }

  static ServiceCategory _categoryFromString(String value) {
    return ServiceCategory.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ServiceCategory.other,
    );
  }
}
