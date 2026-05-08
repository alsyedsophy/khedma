import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;

  const CategoryEntity({required this.id, required this.name, this.imageUrl});

  CategoryEntity copyWith({String? id, String? name, String? imageUrl}) =>
      CategoryEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  List<Object?> get props => [id, name, imageUrl];
}
