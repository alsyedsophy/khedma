import 'package:equatable/equatable.dart';
import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  authenticated,
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
  final UserType? selectedUserType;

  const AuthState({
    this.onboardingStatus = OnboardingStatus.unKnown,
    this.authStatus = AuthStatus.unknown,
    this.user,
    required this.isLoading,
    this.selectedUserType,
  });

  AuthState copyWith({
    OnboardingStatus? onboardingStatus,
    AuthStatus? authStatus,
    UserEntity? user,
    bool? isLoading,
    UserType? selectedUserType,
  }) {
    return AuthState(
      onboardingStatus: onboardingStatus ?? this.onboardingStatus,
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,

      isLoading: isLoading ?? this.isLoading,
      selectedUserType: selectedUserType ?? this.selectedUserType,
    );
  }

  bool get isFirstTime => onboardingStatus == OnboardingStatus.firstTime;
  bool get isFirstTimeDone => onboardingStatus == OnboardingStatus.done;
  bool get isLoggedIn => user != null && authStatus != AuthStatus.authenticated;

  @override
  List<Object?> get props => [
    onboardingStatus,
    authStatus,
    user,
    isLoading,
    selectedUserType,
  ];
}
