import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khedma/core/Utils/accept_offer_result.dart';
import 'package:khedma/core/errors/extentions.dart';
import 'package:khedma/features/Services/data/models/service_request_model.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import '../models/service_offer_model.dart';
import '../models/service_listing_model.dart';

abstract class ServiceRemoteDataSource {
  // Service Requests
  Future<ServiceRequestModel> createServiceRequest(ServiceRequestModel request);
  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId);
  Future<List<ServiceRequestModel>> getOpenRequests();
  Future<List<ServiceRequestModel>> getRequestsByCategory(
    ServiceCategory category,
  );
  Future<ServiceRequestModel> updateRequestStatus(
    String requestId,
    ServiceRequestStatus status, {
    String? acceptedOfferId,
  });
  Future<void> deleteServiceRequest(String requestId);

  // Offers
  Future<ServiceOfferModel> createOffer(ServiceOfferModel offer);
  Future<List<ServiceOfferModel>> getOffersForRequest(String requestId);
  Future<List<ServiceOfferModel>> getOffersByProvider(String providerId);
  Future<AcceptOfferResult> acceptOffer(String offerId, String requestId);
  Future<void> rejectOffer(String offerId);

  // Service Listings
  Future<ServiceListingModel> createServiceListing(ServiceListingModel listing);
  Future<List<ServiceListingModel>> getAllServiceListings();
  Future<List<ServiceListingModel>> getServiceListingsByProvider(
    String providerId,
  );
  Future<ServiceListingModel> updateServiceListingAvailability(
    String listingId,
    bool isAvailable,
  );
  Future<void> deleteServiceListing(String listingId);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final FirebaseFirestore _firestore;

  ServiceRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collections
  CollectionReference get _requestsCollection =>
      _firestore.collection('service_requests');
  CollectionReference get _offersCollection =>
      _firestore.collection('service_offers');
  CollectionReference get _listingsCollection =>
      _firestore.collection('service_listings');
  CollectionReference get _chatCollection => _firestore.collection('chating');

  // ========== Service Requests ==========
  @override
  Future<ServiceRequestModel> createServiceRequest(
    ServiceRequestModel request,
  ) async {
    try {
      final docRef = _requestsCollection.doc();
      final newRequest = ServiceRequestModel(
        id: docRef.id,
        clientId: request.clientId,
        clientName: request.clientName,
        clientImageUrl: request.clientImageUrl,
        title: request.title,
        description: request.description,
        categoryId: request.categoryId,
        category: request.category,
        status: ServiceRequestStatus.open,
        city: request.city,
        governorate: request.governorate,
        budget: request.budget,
        createdAt: DateTime.now(),
        offersCount: 0,
      );
      await docRef.set(newRequest.toFirestore());
      return newRequest;
    } catch (e) {
      throw ServerException(message: 'Failed to create service request: $e');
    }
  }

  @override
  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId) async {
    try {
      final snapshot = await _requestsCollection
          .where('clientId', isEqualTo: clientId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceRequestModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get client requests: $e');
    }
  }

  @override
  Future<List<ServiceRequestModel>> getOpenRequests() async {
    try {
      final snapshot = await _requestsCollection
          .where('status', isEqualTo: 'open')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceRequestModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get open requests: $e');
    }
  }

  @override
  Future<List<ServiceRequestModel>> getRequestsByCategory(
    ServiceCategory category,
  ) async {
    try {
      final catStr = category.toString().split('.').last;
      final snapshot = await _requestsCollection
          .where('category', isEqualTo: catStr)
          .where('status', isEqualTo: 'open')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceRequestModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get requests by category: $e');
    }
  }

  @override
  Future<ServiceRequestModel> updateRequestStatus(
    String requestId,
    ServiceRequestStatus status, {
    String? acceptedOfferId,
  }) async {
    try {
      final data = {
        'status': status.toString().split('.').last,
        'acceptedOfferId': ?acceptedOfferId,
        // if (acceptedOfferId != null) 'acceptedOfferId': acceptedOfferId, احتمال تكون افضل
      };
      await _requestsCollection.doc(requestId).update(data);
      final doc = await _requestsCollection.doc(requestId).get();
      return ServiceRequestModel.fromFirestore(
        (doc.data() as Map<String, dynamic>),
        requestId,
      );
    } catch (e) {
      throw ServerException(message: 'Failed to update request status: $e');
    }
  }

  @override
  Future<void> deleteServiceRequest(String requestId) async {
    try {
      await _requestsCollection.doc(requestId).delete();
    } catch (e) {
      throw ServerException(message: 'Failed to delete request: $e');
    }
  }

  // ========== Offers ==========
  @override
  Future<ServiceOfferModel> createOffer(ServiceOfferModel offer) async {
    try {
      final docRef = _offersCollection.doc();
      final newOffer = ServiceOfferModel(
        id: docRef.id,
        requestId: offer.requestId,
        providerId: offer.providerId,
        providerName: offer.providerName,
        providerImageUrl: offer.providerImageUrl,
        price: offer.price,
        description: offer.description,
        isAccepted: false,
        createdAt: DateTime.now(),
      );
      await docRef.set(newOffer.toFirestore());
      // زيادة عدد العروض في الطلب
      await _requestsCollection.doc(offer.requestId).update({
        'offersCount': FieldValue.increment(1),
      });
      return newOffer;
    } catch (e) {
      throw ServerException(message: 'Failed to create offer: $e');
    }
  }

  @override
  Future<List<ServiceOfferModel>> getOffersForRequest(String requestId) async {
    try {
      final snapshot = await _offersCollection
          .where('requestId', isEqualTo: requestId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceOfferModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get offers: $e');
    }
  }

  @override
  Future<List<ServiceOfferModel>> getOffersByProvider(String providerId) async {
    try {
      final snapshot = await _offersCollection
          .where('providerId', isEqualTo: providerId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceOfferModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get provider offers: $e');
    }
  }

  @override
  Future<AcceptOfferResult> acceptOffer(
    String offerId,
    String requestId,
  ) async {
    try {
      // قبول العرض
      await _offersCollection.doc(offerId).update({'isAccepted': true});
      // رفض باقي العروض (اختياري)
      final offersSnap = await _offersCollection
          .where('requestId', isEqualTo: requestId)
          .where('id', isNotEqualTo: offerId)
          .get();
      for (var doc in offersSnap.docs) {
        await doc.reference.update({'isAccepted': false});
      }
      // تحديث حالة الطلب
      await _requestsCollection.doc(requestId).update({
        'status': 'inProgress',
        'acceptedOfferId': offerId,
      });

      final chatRef = await _chatCollection.add({
        'requestId': requestId,
        'offerId': offerId,
        'createdAt': DateTime.now(),
      });
      final requestDoc = await _requestsCollection.doc(requestId).get();
      final offerDoc = await _offersCollection.doc(offerId).get();
      return _buildAcceptResult(requestDoc, offerDoc, chatRef);
    } catch (e) {
      throw ServerException(message: 'Failed to accept offer: $e');
    }
  }

  @override
  Future<void> rejectOffer(String offerId) async {
    try {
      await _offersCollection.doc(offerId).delete();
    } catch (e) {
      throw ServerException(message: 'Failed to reject offer: $e');
    }
  }

  // ========== Service Listings ==========
  @override
  Future<ServiceListingModel> createServiceListing(
    ServiceListingModel listing,
  ) async {
    try {
      final docRef = _listingsCollection.doc();
      final newListing = ServiceListingModel(
        id: docRef.id,
        providerId: listing.providerId,
        providerName: listing.providerName,
        providerImageUrl: listing.providerImageUrl,
        title: listing.title,
        description: listing.description,
        categoryId: listing.categoryId,
        category: listing.category,
        price: listing.price,
        city: listing.city,
        governorate: listing.governorate,
        isAvailable: true,
        createdAt: DateTime.now(),
      );
      await docRef.set(newListing.toFirestore());
      return newListing;
    } catch (e) {
      throw ServerException(message: 'Failed to create service listing: $e');
    }
  }

  @override
  Future<List<ServiceListingModel>> getAllServiceListings() async {
    try {
      final snapshot = await _listingsCollection
          .where('isAvailable', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceListingModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get service listings: $e');
    }
  }

  @override
  Future<List<ServiceListingModel>> getServiceListingsByProvider(
    String providerId,
  ) async {
    try {
      final snapshot = await _listingsCollection
          .where('providerId', isEqualTo: providerId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map(
            (doc) => ServiceListingModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to get provider listings: $e');
    }
  }

  @override
  Future<ServiceListingModel> updateServiceListingAvailability(
    String listingId,
    bool isAvailable,
  ) async {
    try {
      await _listingsCollection.doc(listingId).update({
        'isAvailable': isAvailable,
      });
      final serviceUpdated = await _listingsCollection.doc(listingId).get();
      return ServiceListingModel.fromFirestore(
        (serviceUpdated.data() as Map<String, dynamic>),
        listingId,
      );
    } catch (e) {
      throw ServerException(
        message: 'Failed to update listing availability: $e',
      );
    }
  }

  @override
  Future<void> deleteServiceListing(String listingId) async {
    try {
      await _listingsCollection.doc(listingId).delete();
    } catch (e) {
      throw ServerException(message: 'Failed to delete listing: $e');
    }
  }

  AcceptOfferResult _buildAcceptResult(
    DocumentSnapshot requestDoc,
    DocumentSnapshot offerDoc,
    DocumentReference chatRef,
  ) {
    return AcceptOfferResult(
      request: ServiceRequestModel.fromFirestore(
        (requestDoc.data() as Map<String, dynamic>),
        requestDoc.id,
      ),
      offer: ServiceOfferModel.fromFirestore(
        (offerDoc.data() as Map<String, dynamic>),
        offerDoc.id,
      ),
      chatId: chatRef.id,
    );
  }
}
