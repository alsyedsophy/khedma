import 'package:equatable/equatable.dart';

class ServiceOfferEntity extends Equatable {
  final String id;
  final String requestId;
  final String providerId;
  final String providerName;
  final String? providerImageUrl;
  final double price;
  final String description;
  final bool isAccepted;
  final DateTime createdAt;

  const ServiceOfferEntity({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.providerName,
    this.providerImageUrl,
    required this.price,
    required this.description,
    this.isAccepted = false,
    required this.createdAt,
  });

  ServiceOfferEntity copyWith({
    String? id,
    String? requestId,
    String? providerId,
    String? providerName,
    String? providerImageUrl,
    double? price,
    String? description,
    bool? isAccepted,
    DateTime? createdAt,
  }) {
    return ServiceOfferEntity(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerImageUrl: providerImageUrl ?? this.providerImageUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      isAccepted: isAccepted ?? this.isAccepted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    requestId,
    providerId,
    providerName,
    providerImageUrl,
    price,
    description,
    isAccepted,
    createdAt,
  ];
}
