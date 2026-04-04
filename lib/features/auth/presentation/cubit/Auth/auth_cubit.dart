import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';
import 'package:khedma/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:khedma/features/auth/domain/usecases/set_location_address_use_case.dart';
import 'package:khedma/features/auth/presentation/cubit/Auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
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
  final VerifiyEmailUseCase verifiyEmailUseCase;
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
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          onboardingStatus: OnboardingStatus.done,
          authStatus: AuthStatus.unauthenticated,
          errorMessage: failure.message,
        ),
      ),
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
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await loginWithEmailUseCase(
      userType: userType,
      email: email,
      password: password,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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

  Future<void> registerWithEmail(
    UserType userType,
    String email,
    String password,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await createAcountUseCase(
      userType: userType,
      email: email,
      password: password,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await loginWithGoogleUseCase(userType: userType);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await loginWithFacebookUseCase(userType: userType);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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

  /// إرسال رابط التحقق من البريد الإلكتروني
  Future<void> sendEmailVerification() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await verifiyEmailUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'تم إرسال رابط التحقق إلى بريدك الإلكتروني',
        ),
      ),
    );
  }

  /// التحقق من حالة البريد الإلكتروني
  Future<void> checkEmailVerified() async {
    emit(state.copyWith(isLoading: true));
    final result = await checkEmailVerifiedUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (isVerified) {
        if (isVerified) {
          // تحديث حالة المستخدم
          final updatedUser = state.user?.copyWith(isEmailVerified: true);
          emit(
            state.copyWith(
              isLoading: false,
              user: updatedUser,
              authStatus: AuthStatus
                  .locationNotSelected, // بعد التحقق، ننتقل إلى اختيار الموقع
              successMessage: 'تم التحقق من بريدك الإلكتروني',
            ),
          );
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage:
                  'لم يتم التحقق بعد. يرجى التحقق من بريدك الإلكتروني',
            ),
          );
        }
      },
    );
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await sendPasswordResetEmailUseCase(email: email);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني',
        ),
      ),
    );
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    final result = await logoutUseCase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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
    // أولاً: تعيين نوع المستخدم
    final result = await setUserTypeUseCase(userType: userType);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) async {
        // ثم تعيين أول مرة كمستخدم
        await setFirstTimeDoneUseCase();
        emit(
          state.copyWith(
            onboardingStatus: OnboardingStatus.done,
            authStatus:
                AuthStatus.unauthenticated, // بعدها يذهب إلى تسجيل الدخول
          ),
        );
      },
    );
  }

  /// تعيين أن المستخدم اختار الموقع (يُستدعى من صفحة الموقع بعد التأكيد)
  Future<void> locationSelected() async {
    final result = await setLocationSelectedUseCase();
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedUser = state.user?.copyWith(isLocationSelected: true);
        emit(
          state.copyWith(
            user: updatedUser,
            authStatus: AuthStatus.profileIncomplete,
          ),
        );
      },
    );
  }

  Future<void> locationAddress(LatLng latLng, String address) async {
    final location = LocationEntity(
      latitude: latLng.latitude,
      langitude: latLng.longitude,
      address: address,
    );
    final result = await setLocationAddressUseCase(location);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updatedUser = state.user?.copyWith(location: location);
        emit(
          state.copyWith(
            user: updatedUser,
            authStatus: AuthStatus.profileIncomplete,
          ),
        );
      },
    );
  }

  /// تحديث الملف الشخصي (الاسم، الهاتف، العنوان، الصورة)
  Future<void> updateProfile({
    String? name,
    String? phone,
    LocationEntity? location,
    XFile? image,
  }) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await updateUserUseCase(
      name: name,
      phone: phone,
      location: location,
      image: image,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
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
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) {
        final updatedUser = state.user?.copyWith(isProfileCompleted: true);
        emit(
          state.copyWith(
            isLoading: false,
            user: updatedUser,
            authStatus: AuthStatus.fullySetup,
            successMessage: 'تم إكمال الملف الشخصي بنجاح',
          ),
        );
      },
    );
  }

  /// مسح الأخطاء والرسائل
  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
