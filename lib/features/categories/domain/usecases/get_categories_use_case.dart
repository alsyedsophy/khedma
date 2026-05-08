import 'package:dartz/dartz.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/features/categories/domain/entities/category_entity.dart';
import 'package:khedma/features/categories/domain/repositories/categories_repo.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final CategoriesRepo repo;

  GetCategoriesUseCase({required this.repo});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return repo.getCategories();
  }
}
