import 'package:equatable/equatable.dart';
import 'package:khedma/features/Subscriptions/domain/entities/plan_entity.dart';
import 'package:khedma/features/Subscriptions/domain/entities/subscription_entity.dart';

sealed class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

// Get Plans States
class PlansLoaded extends SubscriptionState {
  final List<PlanEntity> plans;
  PlansLoaded(this.plans);
}

// Subscription States
class CurrentSubscriptionLoaded extends SubscriptionState {
  final SubscriptionEntity subscription;
  CurrentSubscriptionLoaded(this.subscription);
  @override
  List<Object?> get props => [subscription];
}

class SubscriptionPurchased extends SubscriptionState {
  final SubscriptionEntity subscription;
  SubscriptionPurchased(this.subscription);
  @override
  List<Object?> get props => [subscription];
}

// Quota States

class QuotaUpdated extends SubscriptionState {
  final SubscriptionEntity subscription;
  QuotaUpdated(this.subscription);
  @override
  List<Object?> get props => [subscription];
}

class HasQuotaState extends SubscriptionState {
  final bool hasQuota;
  HasQuotaState(this.hasQuota);
  @override
  List<Object?> get props => [hasQuota];
}

// Error State
class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
  @override
  List<Object?> get props => [message];
}
