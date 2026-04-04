import 'package:flutter/foundation.dart';
import '../../features/auth/presentation/cubit/Auth/auth_cubit.dart';
import '../../features/auth/presentation/cubit/Auth/auth_state.dart';

/// يربط حالة AuthCubit مع GoRouter لإعادة التوجيه التلقائي
class RouterNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  RouterNotifier(this._authCubit) {
    _authCubit.stream.listen((_) => notifyListeners());
  }

  AuthState get authState => _authCubit.state;
}
