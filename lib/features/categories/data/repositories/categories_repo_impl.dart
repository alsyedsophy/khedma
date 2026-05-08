import 'package:dartz/dartz.dart';
import 'package:khedma/core/errors/failures.dart';
import 'package:khedma/core/network/network_info.dart';
import 'package:khedma/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:khedma/features/categories/domain/entities/category_entity.dart';
import 'package:khedma/features/categories/domain/repositories/categories_repo.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  final CategoriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CategoriesRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No Internet Connection'));
    }
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure('$e'));
    }
  }
}
