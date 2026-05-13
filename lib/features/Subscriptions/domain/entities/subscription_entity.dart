import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String id;
  final String planId;
  final DateTime purchaseDate;
  final int remainingRequests;
  final int remainingOffers;
  final bool isActive;

  const SubscriptionEntity({
    required this.id,
    required this.planId,
    required this.purchaseDate,
    required this.remainingRequests,
    required this.remainingOffers,
    required this.isActive,
  });

  SubscriptionEntity copyWith({
    String? id,
    String? planId,
    DateTime? purchaseDate,
    int? remainingRequests,
    int? remainingOffers,
    bool? isActive,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      remainingRequests: remainingRequests ?? this.remainingRequests,
      remainingOffers: remainingOffers ?? this.remainingOffers,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    planId,
    purchaseDate,
    remainingRequests,
    remainingOffers,
    isActive,
  ];

  bool get isExpired =>
      !isActive || remainingRequests <= 0 && remainingOffers <= 0;
}
