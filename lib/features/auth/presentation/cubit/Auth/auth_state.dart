import 'package:equatable/equatable.dart';
import 'package:khedma/core/constants/app_emums.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  unknown, // اريد ان احذف هذه ايضا
  unauthenticated,
  authenticated, // بفكر اشيل دى من هنا واضيفها مكان ال fully setup
  emailUnVerified,
  locationNotSelected,
  locationSelected, // وايضا احذف هذه نهائى
  profileIncomplete,
  fullySetup,
}

enum UserRoleStatus { unKnown, notSelected, done } // تم حذف ال firstTime من هنا

class AuthState extends Equatable {
  final UserRoleStatus userRoleStatus;
  final AuthStatus authStatus;
  final UserEntity? user;
  final bool isLoading;
  final UserType? selectedUserType;

  const AuthState({
    this.userRoleStatus = UserRoleStatus.unKnown,
    this.authStatus = AuthStatus.unknown,
    this.user,
    required this.isLoading,
    this.selectedUserType,
  });

  AuthState copyWith({
    UserRoleStatus? userRoleStatus,
    AuthStatus? authStatus,
    UserEntity? user,
    bool? isLoading,
    UserType? selectedUserType,
  }) {
    return AuthState(
      userRoleStatus: userRoleStatus ?? this.userRoleStatus,
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      selectedUserType: selectedUserType ?? this.selectedUserType,
    );
  }

  bool get isFirstTime => userRoleStatus == UserRoleStatus.notSelected;
  bool get isFirstTimeDone => userRoleStatus == UserRoleStatus.done;
  bool get isLoggedIn =>
      user != null &&
      authStatus != AuthStatus.unauthenticated &&
      authStatus != AuthStatus.unknown;

  @override
  List<Object?> get props => [
    userRoleStatus,
    authStatus,
    user,
    isLoading,
    selectedUserType,
  ];
}
