import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_events.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final _eventController = StreamController<AuthEvents>.broadcast();
  Stream<AuthEvents> get event => _eventController.stream;

  void _errorEvent(String message) {
    if (!_eventController.isClosed) {
      _eventController.add(AuthErrorEvent(message));
    }
  }

  void _successEvent(String message) {
    if (!_eventController.isClosed) {
      _eventController.add(AuthSuccessEvent(message));
    }
  }

  final CheckEmailVerifiedUseCase checkEmailVerifiedUseCase;
  final CreateAcountUseCase createAcountUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final IsFirstTimeUseCase isFirstTimeUseCase;
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final LoginWithFacebookUseCase loginWithFacebookUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LogoutUseCase logoutUseCase;
  final SendPasswordResetEmailUseCase sendPasswordResetEmailUseCase;
  final SetFirstTimeDoneUseCase setFirstTimeDoneUseCase;
  final SetLocationSelectedUseCase setLocationSelectedUseCase;
  final SetLocationAddressUseCase setLocationAddressUseCase;
  final SetUserTypeUseCase setUserTypeUseCase;
  final SetProfileCompletedUseCase setProfileCompletedUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final VerifyEmailUseCase verifiyEmailUseCase;
  AuthCubit({
    required this.checkEmailVerifiedUseCase,
    required this.createAcountUseCase,
    required this.getCachedUserUseCase,
    required this.isFirstTimeUseCase,
    required this.loginWithEmailUseCase,
    required this.loginWithFacebookUseCase,
    required this.loginWithGoogleUseCase,
    required this.logoutUseCase,
    required this.sendPasswordResetEmailUseCase,
    required this.setFirstTimeDoneUseCase,
    required this.setLocationSelectedUseCase,
    required this.setLocationAddressUseCase,
    required this.setUserTypeUseCase,
    required this.setProfileCompletedUseCase,
    required this.updateUserUseCase,
    required this.verifiyEmailUseCase,
  }) : super(const AuthState(isLoading: false));

  AuthStatus _resolveAuthStatus(UserEntity? user) {
    if (user == null) return AuthStatus.unauthenticated;
    if (!user.isEmailVerified) return AuthStatus.emailUnVerified;
    if (!user.isLocationSelected) return AuthStatus.locationNotSelected;
    if (!user.isProfileCompleted) return AuthStatus.profileIncomplete;
    return AuthStatus.fullySetup;
  }

  Future<void> checkAuthState() async {
    emit(state.copyWith(isLoading: true));

    // التحقق من أول مرة
    final isFirstTimeResult = await isFirstTimeUseCase();
    final isFirst = isFirstTimeResult.fold((_) => true, (val) => val);

    if (isFirst) {
      emit(
        state.copyWith(
          isLoading: false,
          onboardingStatus: OnboardingStatus.firstTime,
          authStatus: AuthStatus.unauthenticated,
        ),
      );
      return;
    }

    // التحقق من وجود مستخدم مخبأ
    final userResult = await getCachedUserUseCase();
    userResult.fold(
      (failure) {
        //  فشل الـ cache لا يستدعي snackbar في الـ startup — نسجل فقط
        emit(
          state.copyWith(
            isLoading: false,
            onboardingStatus: OnboardingStatus.done,
            authStatus: AuthStatus.unauthenticated,
          ),
        );
      },
      (user) => emit(
        state.copyWith(
          isLoading: false,
          onboardingStatus: OnboardingStatus.done,
          authStatus: _resolveAuthStatus(user),
          user: user,
        ),
      ),
    );
  }

  Future<void> loginWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await loginWithEmailUseCase(
      userType: userType,
      email: email,
      password: password,
    );
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (user) {
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
            authStatus: _resolveAuthStatus(user),
            onboardingStatus: OnboardingStatus.done,
          ),
        );
      },
    );
  }

  Future<void> registerWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await createAcountUseCase(
      userType: userType,
      email: email,
      password: password,
    );
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (user) => emit(
        state.copyWith(
          isLoading: false,
          user: user,
          authStatus:
              AuthStatus.emailUnVerified, // بعد التسجيل، البريد غير مفعل
          onboardingStatus: OnboardingStatus.done,
        ),
      ),
    );
  }

  /// تسجيل الدخول باستخدام Google
  Future<void> loginWithGoogle(UserType userType) async {
    emit(state.copyWith(isLoading: true));
    final result = await loginWithGoogleUseCase(userType: userType);
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (user) => emit(
        state.copyWith(
          isLoading: false,
          user: user,
          authStatus: _resolveAuthStatus(user),
          onboardingStatus: OnboardingStatus.done,
        ),
      ),
    );
  }

  /// تسجيل الدخول باستخدام Facebook
  Future<void> loginWithFacebook(UserType userType) async {
    emit(state.copyWith(isLoading: true));
    final result = await loginWithFacebookUseCase(userType: userType);
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (user) {
        log(user.toString());
        emit(
          state.copyWith(
            isLoading: false,
            user: user,
            authStatus: _resolveAuthStatus(user),
            onboardingStatus: OnboardingStatus.done,
          ),
        );
      },
    );
  }

  /// إرسال رابط التحقق من البريد الإلكتروني
  Future<void> sendEmailVerification() async {
    emit(state.copyWith(isLoading: true));
    final result = await verifiyEmailUseCase();
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (_) {
        _successEvent('تم إرسال رابط التحقق إلى بريدك الإلكتروني');
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  /// التحقق من حالة البريد الإلكتروني
  Future<void> checkEmailVerified() async {
    emit(state.copyWith(isLoading: true));
    final result = await checkEmailVerifiedUseCase();
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (isVerified) {
        if (isVerified) {
          // تحديث حالة المستخدم
          final updatedUser = state.user?.copyWith(isEmailVerified: true);
          _successEvent('تم التحقق من بريدك الإلكتروني');
          emit(
            state.copyWith(
              isLoading: false,
              user: updatedUser,
              authStatus: AuthStatus
                  .locationNotSelected, // بعد التحقق، ننتقل إلى اختيار الموقع
            ),
          );
        } else {
          _errorEvent('لم يتم التحقق بعد. يرجى التحقق من بريدك الإلكتروني');
          emit(state.copyWith(isLoading: false));
        }
      },
    );
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(isLoading: true));
    final result = await sendPasswordResetEmailUseCase(email: email);
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (_) {
        _successEvent('تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني');
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    final result = await logoutUseCase();
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (_) => emit(
        const AuthState(
          isLoading: false,
          onboardingStatus: OnboardingStatus.done,
          authStatus: AuthStatus.unauthenticated,
        ),
      ),
    );
  }

  /// إكمال شاشة الترحيب (onboarding) وتعيين نوع المستخدم
  Future<void> completeOnboarding(UserType userType) async {
    emit(state.copyWith(isLoading: true));
    log("state in cubit : $state");
    // أولاً: تعيين نوع المستخدم
    final result = await setUserTypeUseCase(userType: userType);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false));
        _errorEvent(failure.message);
      },
      (_) async {
        // ثم تعيين أول مرة كمستخدم
        final firstTimeResult = await setFirstTimeDoneUseCase();
        // log(state.isFirstTime.toString());
        firstTimeResult.fold(
          (failure) {
            emit(state.copyWith(isLoading: false));
            _errorEvent(failure.message);
          },
          (_) => emit(
            state.copyWith(
              isLoading: false,
              onboardingStatus: OnboardingStatus.done,
              authStatus:
                  AuthStatus.unauthenticated, // بعدها يذهب إلى تسجيل الدخول
              selectedUserType: userType,
            ),
          ),
        );
      },
    );
  }

  /// تعيين أن المستخدم اختار الموقع (يُستدعى من صفحة الموقع بعد التأكيد)
  Future<void> locationSelected() async {
    final result = await setLocationSelectedUseCase();
    result.fold((failure) => _errorEvent(failure.message), (_) {
      final updatedUser = state.user?.copyWith(isLocationSelected: true);
      emit(
        state.copyWith(
          user: updatedUser,
          authStatus: AuthStatus.profileIncomplete,
        ),
      );
    });
  }

  Future<void> locationAddress(LatLng latLng, String address) async {
    final location = LocationEntity(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      address: address,
    );
    final result = await setLocationAddressUseCase(latLng, address);
    result.fold((failure) => _errorEvent(failure.message), (_) {
      final updatedUser = state.user?.copyWith(location: location);
      emit(
        state.copyWith(
          user: updatedUser,
          authStatus: AuthStatus.profileIncomplete,
        ),
      );
    });
  }

  /// تحديث الملف الشخصي (الاسم، الهاتف، العنوان، الصورة)
  Future<void> updateProfile({
    String? name,
    String? phone,
    LocationEntity? location,
    XFile? image,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await updateUserUseCase(
      name: name,
      phone: phone,
      location: location,
      image: image,
    );
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (_) {
        // بعد التحديث، نرسل حدث اكتمال الملف
        _completeProfile();
      },
    );
  }

  /// تعيين اكتمال الملف الشخصي (يُستدعى بعد updateProfile أو بشكل منفصل)
  Future<void> _completeProfile() async {
    final result = await setProfileCompletedUseCase();
    result.fold(
      (failure) {
        _errorEvent(failure.message);
        emit(state.copyWith(isLoading: false));
      },
      (_) {
        final updatedUser = state.user?.copyWith(isProfileCompleted: true);
        _successEvent('تم إكمال الملف الشخصي بنجاح');
        emit(
          state.copyWith(
            isLoading: false,
            user: updatedUser,
            authStatus: AuthStatus.fullySetup,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _eventController.close();
    return super.close();
  }
}
