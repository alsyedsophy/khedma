import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../features/auth/presentation/cubit/Auth/auth_cubit.dart';
import '../../features/auth/presentation/cubit/Auth/auth_state.dart';

/// يربط حالة AuthCubit مع GoRouter لإعادة التوجيه التلقائي
class RouterNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;
  late final StreamSubscription _sub;

  AuthState authState;

  RouterNotifier(this._authCubit) : authState = _authCubit.state {
    _sub = _authCubit.stream.listen((state) {
      authState = state;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
