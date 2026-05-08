import 'package:khedma/features/Services/domain/entities/serice_request_entity.dart';
import 'package:khedma/features/Services/domain/entities/service_offer_entity.dart';

class AcceptOfferResult {
  final ServiceRequestEntity request;
  final ServiceOfferEntity offer;
  final String chatId;

  AcceptOfferResult({
    required this.request,
    required this.offer,
    required this.chatId,
  });
}
