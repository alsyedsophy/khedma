import 'package:equatable/equatable.dart';
import 'package:khedma/Core/constants/app_emums.dart';

// كيان المستخدم (يمثل البيانات الأساسية للمستخدم في طبقة domain)
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final LocationEntity? location;
  final String? profileImageUrl;
  final bool isEmailVerified;
  final bool isLocationSelected;
  final bool isProfileCompleted;
  final UserType userType; // نوع المستخدم: service أو provider

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.location,
    this.profileImageUrl,
    required this.isEmailVerified,
    required this.isLocationSelected,
    required this.isProfileCompleted,
    required this.userType,
  });

  // نسخة معدلة من الكائن
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    LocationEntity? location,
    String? profileImageUrl,
    bool? isEmailVerified,
    bool? isLocationSelected,
    bool? isProfileCompleted,
    UserType? userType,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isLocationSelected: isLocationSelected ?? this.isLocationSelected,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phone,
    location,
    profileImageUrl,
    isEmailVerified,
    isLocationSelected,
    isProfileCompleted,
    userType,
  ];
}

class LocationEntity extends Equatable {
  final double latitude;
  final double langitude;
  final String address;

  const LocationEntity({
    required this.latitude,
    required this.langitude,
    required this.address,
  });

  @override
  List<Object?> get props => [langitude, langitude, address];
}
