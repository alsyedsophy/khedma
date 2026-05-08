import 'package:equatable/equatable.dart';
import 'package:khedma/core/Utils/accept_offer_result.dart';
import 'package:khedma/features/Services/domain/entities/service_offer_entity.dart';

/// حالات عروض الخدمة
abstract class ServiceOfferState extends Equatable {
  const ServiceOfferState();
  @override
  List<Object?> get props => [];
}

class ServiceOfferInitial extends ServiceOfferState {}

class ServiceOfferLoading extends ServiceOfferState {}

/// تم تحميل قائمة العروض بنجاح
class ServiceOffersLoaded extends ServiceOfferState {
  final List<ServiceOfferEntity> offers;
  const ServiceOffersLoaded(this.offers);
  @override
  List<Object?> get props => [offers];
}

/// تم إنشاء عرض جديد
class ServiceOfferCreated extends ServiceOfferState {
  final ServiceOfferEntity offer;
  const ServiceOfferCreated(this.offer);
  @override
  List<Object?> get props => [offer];
}

/// تم قبول عرض
class ServiceOfferAccepted extends ServiceOfferState {
  final AcceptOfferResult acceptOfferResult;
  const ServiceOfferAccepted(this.acceptOfferResult);
  @override
  List<Object?> get props => [acceptOfferResult];
}

/// تم رفض/حذف عرض
class ServiceOfferRejected extends ServiceOfferState {
  final String offerId;
  const ServiceOfferRejected(this.offerId);
  @override
  List<Object?> get props => [offerId];
}

class ServiceOfferError extends ServiceOfferState {
  final String message;
  const ServiceOfferError(this.message);
  @override
  List<Object?> get props => [message];
}
