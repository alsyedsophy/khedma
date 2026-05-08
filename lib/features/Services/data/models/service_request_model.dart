import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';

class ServiceRequestModel extends ServiceRequestEntity {
  const ServiceRequestModel({
    required super.id,
    required super.clientId,
    required super.clientName,
    super.clientImageUrl,
    required super.title,
    required super.description,
    required super.categoryId,
    required super.category,
    required super.status,
    required super.city,
    required super.governorate,
    super.budget,
    required super.createdAt,
    super.acceptedOfferId,
    super.offersCount,
  });

  // من Firestore
  factory ServiceRequestModel.fromFirestore(
    Map<String, dynamic> map,
    String id,
  ) {
    return ServiceRequestModel(
      id: id,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      clientImageUrl: map['clientImageUrl'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      category: _categoryFromString(map['category']),
      status: _statusFromString(map['status']),
      city: map['city'] ?? '',
      governorate: map['governorate'] ?? '',
      budget: (map['budget'] as num?)?.toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      acceptedOfferId: map['acceptedOfferId'],
      offersCount: map['offersCount'] ?? 0,
    );
  }

  // إلى Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'clientImageUrl': clientImageUrl,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'city': city,
      'governorate': governorate,
      'budget': budget,
      'createdAt': FieldValue.serverTimestamp(),
      'acceptedOfferId': acceptedOfferId,
      'offersCount': offersCount,
    };
  }

  // من كيان
  factory ServiceRequestModel.fromEntity(ServiceRequestEntity entity) {
    return ServiceRequestModel(
      id: entity.id,
      clientId: entity.clientId,
      clientName: entity.clientName,
      clientImageUrl: entity.clientImageUrl,
      title: entity.title,
      description: entity.description,
      categoryId: entity.categoryId,
      category: entity.category,
      status: entity.status,
      city: entity.city,
      governorate: entity.governorate,
      budget: entity.budget,
      createdAt: entity.createdAt,
      acceptedOfferId: entity.acceptedOfferId,
      offersCount: entity.offersCount,
    );
  }

  static ServiceCategory _categoryFromString(String value) {
    return ServiceCategory.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ServiceCategory.other,
    );
  }

  static ServiceRequestStatus _statusFromString(String value) {
    return ServiceRequestStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => ServiceRequestStatus.open,
    );
  }
}
