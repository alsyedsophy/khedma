import 'package:equatable/equatable.dart';

enum ServiceRequestStatus {
  open, // waiting for offers
  inProgress, // offer accepted, work ongoing
  completed, // done
  cancelled, // cancelled by service user
}

enum ServiceCategory {
  plumbing,
  electrical,
  cleaning,
  painting,
  carpentry,
  airConditioning,
  other,
}

class ServiceRequestEntity extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String? clientImageUrl;
  final String title;
  final String description;
  final String categoryId;
  final ServiceCategory category;
  final ServiceRequestStatus status;
  final String city;
  final String governorate;
  final double? budget; // optional max budget from client
  final DateTime createdAt;
  final String? acceptedOfferId;
  final int offersCount;

  const ServiceRequestEntity({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientImageUrl,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.category,
    required this.status,
    required this.city,
    required this.governorate,
    this.budget,
    required this.createdAt,
    this.acceptedOfferId,
    this.offersCount = 0,
  });

  bool get isOpen => status == ServiceRequestStatus.open;

  ServiceRequestEntity copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientImageUrl,
    String? title,
    String? description,
    String? categoryId,
    ServiceCategory? category,
    ServiceRequestStatus? status,
    String? city,
    String? governorate,
    double? budget,
    DateTime? createdAt,
    String? acceptedOfferId,
    int? offersCount,
  }) {
    return ServiceRequestEntity(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientImageUrl: clientImageUrl ?? this.clientImageUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      status: status ?? this.status,
      city: city ?? this.city,
      governorate: governorate ?? this.governorate,
      budget: budget ?? this.budget,
      createdAt: createdAt ?? this.createdAt,
      acceptedOfferId: acceptedOfferId ?? this.acceptedOfferId,
      offersCount: offersCount ?? this.offersCount,
    );
  }

  @override
  List<Object?> get props => [
    id,
    clientId,
    clientName,
    clientImageUrl,
    title,
    description,
    categoryId,
    category,
    status,
    city,
    governorate,
    budget,
    createdAt,
    acceptedOfferId,
    offersCount,
  ];
}
