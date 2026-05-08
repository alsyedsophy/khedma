import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:khedma/core/errors/extentions.dart';
import 'package:khedma/features/categories/data/models/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoriesRemoteDataSourceImpl implements CategoriesRemoteDataSource {
  final FirebaseFirestore _firestore;

  CategoriesRemoteDataSourceImpl({required FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _categoriesCollection =>
      _firestore.collection('categories');

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _categoriesCollection.get();

      return snapshot.docs
          .map(
            (doc) => CategoryModel.fromFirestore(
              (doc.data() as Map<String, dynamic>),
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: 'Faild To Get Categories : $e');
    }
  }
}
