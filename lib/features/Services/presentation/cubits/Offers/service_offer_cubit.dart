import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/Services/domain/usecases/services_usecases.dart';
import 'package:khedma/features/Services/presentation/cubits/Offers/service_offer_state.dart';

/// Cubit لإدارة عروض الخدمة
/// - لمقدم الخدمة: إنشاء عرض على طلب، عرض عروضه السابقة
/// - للعميل: عرض العروض الواردة على طلبه، قبول أو رفض عرض
class ServiceOfferCubit extends Cubit<ServiceOfferState> {
  final CreateOfferUseCase _createOffer;
  final GetOffersForRequestUseCase _getOffersForRequest;
  final GetMyOffersUseCase _getMyOffers;
  final AcceptOfferUseCase _acceptOffer;
  final RejectOfferUseCase _rejectOffer;

  ServiceOfferCubit({
    required CreateOfferUseCase createOffer,
    required GetOffersForRequestUseCase getOffersForRequest,
    required GetMyOffersUseCase getMyOffers,
    required AcceptOfferUseCase acceptOffer,
    required RejectOfferUseCase rejectOffer,
  }) : _createOffer = createOffer,
       _getOffersForRequest = getOffersForRequest,
       _getMyOffers = getMyOffers,
       _acceptOffer = acceptOffer,
       _rejectOffer = rejectOffer,
       super(ServiceOfferInitial());

  Future<void> createOffer(CreateOfferParams params) async {
    emit(ServiceOfferLoading());
    final result = await _createOffer(params);
    result.fold(
      (failure) => emit(ServiceOfferError(failure.message)),
      (offer) => emit(ServiceOfferCreated(offer)),
    );
  }

  Future<void> loadOffersForRequest(String requestId) async {
    emit(ServiceOfferLoading());
    final result = await _getOffersForRequest(
      GetOffersForRequestParams(requestId: requestId),
    );
    result.fold(
      (failure) => emit(ServiceOfferError(failure.message)),
      (offers) => emit(ServiceOffersLoaded(offers)),
    );
  }

  Future<void> loadMyOffers(String providerId) async {
    emit(ServiceOfferLoading());
    final result = await _getMyOffers(
      GetMyOffersParams(providerId: providerId),
    );
    result.fold(
      (failure) => emit(ServiceOfferError(failure.message)),
      (offers) => emit(ServiceOffersLoaded(offers)),
    );
  }

  Future<void> acceptOffer(String offerId, String requestId) async {
    emit(ServiceOfferLoading());
    final result = await _acceptOffer(
      AcceptOfferParams(offerId: offerId, requestId: requestId),
    );
    result.fold(
      (failure) => emit(ServiceOfferError(failure.message)),
      (accept) => emit(ServiceOfferAccepted(accept)),
    );
  }

  Future<void> rejectOffer(String offerId) async {
    emit(ServiceOfferLoading());
    final result = await _rejectOffer(RejectOfferParams(offerId: offerId));
    result.fold(
      (failure) => emit(ServiceOfferError(failure.message)),
      (_) => emit(ServiceOfferRejected(offerId)),
    );
  }
}
