import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/core/Utils/use_case.dart';
import 'package:khedma/features/categories/domain/usecases/get_categories_use_case.dart';
import 'package:khedma/features/categories/presentation/bloc/categories_event.dart';
import 'package:khedma/features/categories/presentation/bloc/categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase getCategories;

  CategoriesBloc(this.getCategories) : super(CategoriesInitial()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(CategoriesLoading());

      final result = await getCategories(NoParams());

      result.fold(
        (failure) => emit(CategoriesError(failure.message)),
        (categories) => emit(CategoriesLoaded(categories)),
      );
    });
  }
}
