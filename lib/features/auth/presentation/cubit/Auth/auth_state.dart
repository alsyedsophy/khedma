import 'package:equatable/equatable.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  unKnown,
  unauthenticated,
  authentecated,
  emailUnVerified,
  locationNotSelected,
  profileIncomplete,
  fullySetup,
}

enum OnboardingStatus { unKnown, firstTime, done }

class AuthState extends Equatable {
  final OnboardingStatus onboardingStatus;
  final AuthStatus authStatus;
  final UserEntity? user;
  final bool isLoading;
  final bool? clearSuccess;
  final bool? clearError;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.onboardingStatus = OnboardingStatus.unKnown,
    this.authStatus = AuthStatus.unKnown,
    this.user,
    this.clearSuccess,
    this.clearError,
    required this.isLoading,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    OnboardingStatus? onboardingStatus,
    AuthStatus? authStatus,
    UserEntity? user,
    bool? clearSuccess,
    bool? clearError,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      clearSuccess: clearSuccess ?? this.clearSuccess,
      clearError: clearError ?? this.clearError,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get isFirstTime => onboardingStatus == OnboardingStatus.firstTime;
  bool get isLoggedIn =>
      user != null && authStatus != AuthStatus.unauthenticated;

  @override
  List<Object?> get props => [
    onboardingStatus,
    authStatus,
    user,
    clearSuccess,
    clearError,
    isLoading,
    errorMessage,
    successMessage,
  ];
}
