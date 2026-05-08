import 'package:equatable/equatable.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';

/// حالات طلبات الخدمة
abstract class ServiceRequestState extends Equatable {
  const ServiceRequestState();
  @override
  List<Object?> get props => [];
}

/// الحالة الابتدائية
class ServiceRequestInitial extends ServiceRequestState {}

/// جاري التحميل
class ServiceRequestLoading extends ServiceRequestState {}

/// تم تحميل قائمة الطلبات بنجاح
class ServiceRequestsLoaded extends ServiceRequestState {
  final List<ServiceRequestEntity> requests;
  const ServiceRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

/// تم إنشاء طلب جديد بنجاح
class ServiceRequestCreated extends ServiceRequestState {
  final ServiceRequestEntity request;
  const ServiceRequestCreated(this.request);
  @override
  List<Object?> get props => [request];
}

/// تم تحديث حالة طلب
class ServiceRequestUpdated extends ServiceRequestState {
  final ServiceRequestEntity request;
  const ServiceRequestUpdated(this.request);
  @override
  List<Object?> get props => [request];
}

/// تم حذف طلب
class ServiceRequestDeleted extends ServiceRequestState {
  final String requestId;
  const ServiceRequestDeleted(this.requestId);
  @override
  List<Object?> get props => [requestId];
}

/// حدث خطأ ما
class ServiceRequestError extends ServiceRequestState {
  final String message;
  const ServiceRequestError(this.message);
  @override
  List<Object?> get props => [message];
}
