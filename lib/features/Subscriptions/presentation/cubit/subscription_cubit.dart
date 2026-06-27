import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/plan_entity.dart';

import '../../domain/usecases/subscriptions_use_cases.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetPlansUseCase getPlansUseCase;
  final PurchasePlanUseCase purchasePlanUseCase;
  final GetCurrentSubUseCase getCurrentSubscriptionUseCase;
  final RestorePurchasesUseCase restorePurchasesUseCase;
  final CheckQuotasUseCase checkQuotaUseCase;
  final IncrementQuotaUseCase incrementQuotaUseCase;

  SubscriptionCubit({
    required this.getPlansUseCase,
    required this.purchasePlanUseCase,
    required this.getCurrentSubscriptionUseCase,
    required this.restorePurchasesUseCase,
    required this.checkQuotaUseCase,
    required this.incrementQuotaUseCase,
  }) : super(SubscriptionInitial());

  Future<void> getPlans() async {
    emit(SubscriptionLoading());
    final result = await getPlansUseCase();
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (plans) => emit(PlansLoaded(plans)),
    );
  }

  Future<void> getCurrentSubscription(String userId) async {
    emit(SubscriptionLoading());
    final result = await getCurrentSubscriptionUseCase(userId);
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscription) => emit(CurrentSubscriptionLoaded(subscription)),
    );
  }

  Future<void> purchasePlan(PlanEntity plan, String userId) async {
    emit(SubscriptionLoading());
    final result = await purchasePlanUseCase(plan, userId);
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscription) => emit(SubscriptionPurchased(subscription)),
    );
  }

  Future<void> restorePurchases(String userId) async {
    emit(SubscriptionLoading());
    final result = await restorePurchasesUseCase(userId);
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (subscription) => emit(CurrentSubscriptionLoaded(subscription)),
    );
  }

  Future<void> checkQuota(String userId) async {
    final result = await checkQuotaUseCase(userId);
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (hasQuota) => emit(HasQuotaState(hasQuota)),
    );
  }

  Future<void> incrementQuota(String userId) async {
    emit(SubscriptionLoading());

    final result = await incrementQuotaUseCase(userId);

    result.fold((failure) => emit(SubscriptionError(failure.message)), (
      _,
    ) async {
      // بعد النجاح، نجلب الاشتراك المحدث
      final updatedResult = await getCurrentSubscriptionUseCase(userId);
      updatedResult.fold(
        (failure) => emit(SubscriptionError(failure.message)),
        (updatedSubscription) => emit(QuotaUpdated(updatedSubscription)),
      );
    });
  }
}
