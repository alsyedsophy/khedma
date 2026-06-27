import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String id;
  final String planId;
  final DateTime purchaseDate;
  final int remainingCredits;
  final bool isActive;

  const SubscriptionEntity({
    required this.id,
    required this.planId,
    required this.purchaseDate,
    required this.remainingCredits,
    required this.isActive,
  });

  SubscriptionEntity copyWith({
    String? id,
    String? planId,
    DateTime? purchaseDate,
    int? remainingCredits,
    bool? isActive,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      remainingCredits: remainingCredits ?? this.remainingCredits,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    planId,
    purchaseDate,
    remainingCredits,
    isActive,
  ];

  bool get isExpired => !isActive || remainingCredits <= 0;
}
