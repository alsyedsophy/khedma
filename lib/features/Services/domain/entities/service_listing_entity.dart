import 'package:equatable/equatable.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';

class ServiceListingEntity extends Equatable {
  final String id;
  final String providerId;
  final String providerName;
  final String? providerImageUrl;
  final String title;
  final String description;
  final String categoryId;
  final ServiceCategory category;
  final double price;
  final String city;
  final String governorate;
  final bool isAvailable;
  final DateTime createdAt;

  const ServiceListingEntity({
    required this.id,
    required this.providerId,
    required this.providerName,
    this.providerImageUrl,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.category,
    required this.price,
    required this.city,
    required this.governorate,
    this.isAvailable = true,
    required this.createdAt,
  });

  ServiceListingEntity copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? providerImageUrl,
    String? title,
    String? description,
    String? categoryId,
    ServiceCategory? category,
    double? price,
    String? city,
    String? governorate,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return ServiceListingEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerImageUrl: providerImageUrl ?? this.providerImageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      price: price ?? this.price,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    providerId,
    providerName,
    providerImageUrl,
    title,
    description,
    categoryId,
    category,
    price,
    city,
    governorate,
    isAvailable,
    createdAt,
  ];
}
