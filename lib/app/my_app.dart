import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khedma/Core/routing/rout_config.dart';
import 'package:khedma/app/dependenc_injections.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(380, 845),
      builder: (context, child) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Khedma',
          routerConfig: sl<RoutConfig>().goRouter,
        ),
      ),
    );
  }
}
