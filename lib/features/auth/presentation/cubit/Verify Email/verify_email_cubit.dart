import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khedma/features/auth/presentation/cubit/Verify%20Email/verify_email_state.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit() : super(VerifyEmailInitial());

  Timer? _timer;
  int _seconds = 60;

  void startTimer() {
    _seconds = 60;

    emit(VerifyEmailCounting(_seconds));

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds--;

      if (_seconds > 0) {
        emit(VerifyEmailCounting(_seconds));
      } else {
        timer.cancel();
        emit(VerifyEmailFinished());
      }
    });
  }

  void resetTimer() {
    startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
