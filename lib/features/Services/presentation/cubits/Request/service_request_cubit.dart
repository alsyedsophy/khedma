import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/usecases/services_usecases.dart';
import 'package:khedma/features/Services/presentation/cubits/Request/service_request_state.dart';

/// Cubit لإدارة طلبات الخدمة
/// - للعميل: إنشاء طلب، عرض طلباته، تحديث الحالة، حذف
/// - لمقدم الخدمة: عرض الطلبات المفتوحة، التصفية حسب التصنيف
class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  final CreateServiceRequestUseCase _createServiceRequest;
  final GetMyRequestsUseCase _getMyRequests;
  final GetOpenRequestsUseCase _getOpenRequests;
  final GetRequestsByCategoryUseCase _getRequestsByCategory;
  final UpdateRequestStatusUseCase _updateRequestStatus;
  final DeleteServiceRequestUseCase _deleteServiceRequest;

  ServiceRequestCubit({
    required CreateServiceRequestUseCase createServiceRequest,
    required GetMyRequestsUseCase getMyRequests,
    required GetOpenRequestsUseCase getOpenRequests,
    required GetRequestsByCategoryUseCase getRequestsByCategory,
    required UpdateRequestStatusUseCase updateRequestStatus,
    required DeleteServiceRequestUseCase deleteServiceRequest,
  }) : _createServiceRequest = createServiceRequest,
       _getMyRequests = getMyRequests,
       _getOpenRequests = getOpenRequests,
       _getRequestsByCategory = getRequestsByCategory,
       _updateRequestStatus = updateRequestStatus,
       _deleteServiceRequest = deleteServiceRequest,
       super(ServiceRequestInitial());

  Future<void> createRequest(CreateServiceRequestParams params) async {
    emit(ServiceRequestLoading());
    final result = await _createServiceRequest(params);
    result.fold(
      (failure) => emit(ServiceRequestError(failure.message)),
      (request) => emit(ServiceRequestCreated(request)),
    );
  }

  Future<void> loadMyRequests(String clientId) async {
    emit(ServiceRequestLoading());
    final result = await _getMyRequests(
      GetMyRequestsParams(clientId: clientId),
    );
    result.fold(
      (failure) => emit(ServiceRequestError(failure.message)),
      (requests) => emit(ServiceRequestsLoaded(requests)),
    );
  }

  Future<void> loadOpenRequests() async {
    emit(ServiceRequestLoading());
    final result = await _getOpenRequests(NoParams());
    result.fold(
      (failure) => emit(ServiceRequestError(failure.message)),
      (requests) => emit(ServiceRequestsLoaded(requests)),
    );
  }

  Future<void> loadRequestsByCategory(ServiceCategory category) async {
    emit(ServiceRequestLoading());
    final result = await _getRequestsByCategory(
      GetRequestsByCategoryParams(category: category),
    );
    result.fold(
      (failure) => emit(ServiceRequestError(failure.message)),
      (requests) => emit(ServiceRequestsLoaded(requests)),
    );
  }

  Future<void> updateStatus(
    String requestId,
    ServiceRequestStatus newStatus,
  ) async {
    emit(ServiceRequestLoading());
    final result = await _updateRequestStatus(
      UpdateRequestStatusParams(requestId: requestId, status: newStatus),
    );
    result.fold(
      (failure) => emit(ServiceRequestError(failure.message)),
      (uupatedRequest) => emit(ServiceRequestUpdated(uupatedRequest)),
    );
  }

  Future<void> deleteRequest(String requestId) async {
    emit(ServiceRequestLoading());
    final result = await _deleteServiceRequest(
      DeleteServiceRequestParams(requestId: requestId),
    );
    result.fold(
      (failure) => emit(ServiceRequestError(failure.message)),
      (_) => emit(ServiceRequestDeleted(requestId)),
    );
  }
}
