import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_events.dart';

mixin AuthEventListenerMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<AuthCubit>();

    _sub = cubit.event.listen((event) {
      if (!mounted) return;

      if (event is AuthErrorEvent) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(event.message)));
      }

      if (event is AuthSuccessEvent) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(event.message)));
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
