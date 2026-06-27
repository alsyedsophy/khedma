import 'package:equatable/equatable.dart';

class PlanEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final String currency;
  final int credits;
  final String? description;
  final String? storeProductIdAndroid;
  final String? storeProductIdIos;

  const PlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.credits,
    this.description,
    this.storeProductIdAndroid,
    this.storeProductIdIos,
  });

  PlanEntity copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    int? credits,
    String? description,
    String? storeProductIdAndroid,
    String? storeProductIdIos,
  }) {
    return PlanEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      credits: credits ?? this.credits,
      description: description ?? this.description,
      storeProductIdAndroid:
          storeProductIdAndroid ?? this.storeProductIdAndroid,
      storeProductIdIos: storeProductIdIos ?? this.storeProductIdIos,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    currency,
    credits,
    description,
    storeProductIdAndroid,
    storeProductIdIos,
  ];
}
