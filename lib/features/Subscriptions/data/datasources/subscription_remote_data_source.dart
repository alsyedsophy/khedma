import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/extentions.dart';
import '../models/plan_model.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<PlanModel>> getPlans();
  Future<SubscriptionModel> purchasePlan(PlanModel plan, String userId);
  Future<SubscriptionModel> getCurrentSubscription(String userId);
  Future<SubscriptionModel> restorePurchases(String userId);
  Future<bool> hasQuota(String userId);
  Future<void> incrementQuota(String userId);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final FirebaseFirestore _firestore;

  SubscriptionRemoteDataSourceImpl(FirebaseFirestore? firestore)
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _plansCollection => _firestore.collection('Plans');
  CollectionReference get _subscriptionsCollection =>
      _firestore.collection('Subscriptions');

  @override
  Future<List<PlanModel>> getPlans() async {
    try {
      final snapshot = await _plansCollection.orderBy('price').get();
      return snapshot.docs
          .map(
            (doc) => PlanModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SubscriptionModel> purchasePlan(PlanModel plan, String userId) async {
    try {
      final subscriptionRef = _subscriptionsCollection.doc(userId);

      final newSubscription = SubscriptionModel(
        id: 'sub_$userId',
        planId: plan.id,
        purchaseDate: DateTime.now(),
        remainingCredits: plan.credits,
        isActive: true,
      );

      await subscriptionRef.set(newSubscription.toFirestore());

      return newSubscription;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<SubscriptionModel> getCurrentSubscription(String userId) async {
    try {
      final doc = await _subscriptionsCollection.doc(userId).get();

      if (!doc.exists) {
        throw CacheException("No active subscription found");
      }

      return SubscriptionModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  //! =============================================================
  @override
  Future<SubscriptionModel> restorePurchases(String userId) async {
    try {
      // هنا يمكنك إضافة منطق In-App Purchase restore لاحقاً
      // حالياً نرجع الاشتراك الحالي
      return await getCurrentSubscription(userId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> hasQuota(String userId) async {
    try {
      final subscription = await getCurrentSubscription(userId);

      if (!subscription.isActive) return false;

      return subscription.remainingCredits > 0;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> incrementQuota(String userId) async {
    try {
      final docRef = _subscriptionsCollection.doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) return;
        final cridets = snapshot['remainingCredits'];
        if (cridets <= 0) {
          throw CacheException('No Found Quotas');
        }

        transaction.update(docRef, {
          'remainingCredits': FieldValue.increment(-1),
        });
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
