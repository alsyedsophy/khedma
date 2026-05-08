import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({required super.id, required super.name, super.imageUrl});

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String id) {
    return CategoryModel(
      id: id,
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'imageUrl': imageUrl};
  }

  factory CategoryModel.fromEntity(CategoryEntity category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      imageUrl: category.imageUrl,
    );
  }
}
