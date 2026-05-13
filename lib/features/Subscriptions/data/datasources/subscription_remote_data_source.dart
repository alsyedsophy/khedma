import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/extentions.dart';
import '../models/plan_model.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<PlanModel>> getPlans();
  Future<SubscriptionModel> purchasePlan(PlanModel plan, String userId);
  Future<SubscriptionModel> getCurrentSubscription(String userId);
  Future<SubscriptionModel> restorePurchases(String userId);
  Future<bool> isSubscriptionActive(String userId);
  Future<bool> hasQuota(String userId, {required bool isClient});
  Future<void> incrementQuota(String userId, {required bool isClient});
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
      final snapshot = await _plansCollection.get();
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
        remainingRequests: plan.maxRequests,
        remainingOffers: plan.maxOffers,
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
        throw ServerException(message: "No active subscription found");
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
  Future<bool> isSubscriptionActive(String userId) async {
    try {
      final subscription = await getCurrentSubscription(userId);
      return subscription.isActive &&
          (subscription.remainingRequests > 0 ||
              subscription.remainingOffers > 0);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> hasQuota(String userId, {required bool isClient}) async {
    try {
      final subscription = await getCurrentSubscription(userId);

      if (!subscription.isActive) return false;

      if (isClient) {
        return subscription.remainingRequests > 0;
      } else {
        return subscription.remainingOffers > 0;
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> incrementQuota(String userId, {required bool isClient}) async {
    try {
      final docRef = _subscriptionsCollection.doc(userId);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) return;

        if (isClient) {
          transaction.update(docRef, {
            'remainingRequests': FieldValue.increment(-1),
          });
        } else {
          transaction.update(docRef, {
            'remainingOffers': FieldValue.increment(-1),
          });
        }
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
