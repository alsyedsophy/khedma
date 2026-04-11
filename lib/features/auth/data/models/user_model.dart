import 'dart:developer';

import 'package:khedma/Core/constants/app_emums.dart';
import 'package:khedma/features/auth/domain/entities/user_entity.dart';

// نموذج المستخدم (يستخدم في طبقة البيانات)
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.name,
    super.phone,
    super.location,
    super.profileImageUrl,
    required super.isEmailVerified,
    required super.isLocationSelected,
    required super.isProfileCompleted,
    required super.userType,
  });

  // تحويل من Firestore إلى UserModel
  factory UserModel.fromFirestore(
    Map<String, dynamic> map, {
    required String uid,
  }) {
    return UserModel(
      id: uid,
      email: map['email'] ?? '',
      name: map['name'],
      phone: map['phone'],
      location: map['location'] != null
          ? LocationModel.fromMap(map['location'])
          : null,
      profileImageUrl: map['profileImageUrl'],
      isEmailVerified: map['isEmailVerified'] ?? false,
      isLocationSelected: map['isLocationSelected'] ?? false,
      isProfileCompleted: map['isProfileCompleted'] ?? false,
      userType: map['userType'] == 'service'
          ? UserType.service
          : UserType.provider,
    );
  }

  // تحويل UserModel إلى Map لتخزينه في Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'location': location != null ? (location as LocationModel).toMap() : null,
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'isLocationSelected': isLocationSelected,
      'isProfileCompleted': isProfileCompleted,
      'userType': userType.toString().split('.').last, // تحويل enum إلى نص
    };
  }

  // داخل UserModel
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'location': location != null ? (location as LocationModel).toMap() : null,
      'profileImageUrl': profileImageUrl,
      'isEmailVerified': isEmailVerified,
      'isLocationSelected': isLocationSelected,
      'isProfileCompleted': isProfileCompleted,
      'userType': userType.toString().split('.').last,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      log('Parsing UserModel from JSON: $json');
      final userTypeString = json['userType'] as String? ?? 'service';
      final userType = UserType.values.firstWhere(
        (e) => e.toString().split('.').last == userTypeString,
        orElse: () => UserType.service,
      );
      return UserModel(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        phone: json['phone'] as String?,
        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        profileImageUrl: json['profileImageUrl'] as String?,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        isLocationSelected: json['isLocationSelected'] as bool? ?? false,
        isProfileCompleted: json['isProfileCompleted'] as bool? ?? false,
        userType: userType,
      );
    } catch (e, stack) {
      log('ERROR in UserModel.fromJson: $e\n$stack');
      rethrow;
    }
  }

  // تحويل من UserEntity إلى UserModel
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      location: entity.location,
      profileImageUrl: entity.profileImageUrl,
      isEmailVerified: entity.isEmailVerified,
      isLocationSelected: entity.isLocationSelected,
      isProfileCompleted: entity.isProfileCompleted,
      userType: entity.userType,
    );
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.address,
  });

  factory LocationModel.fromMap(Map<String, dynamic> data) => LocationModel(
    latitude: (data['latitude'] as num).toDouble(),
    longitude: (data['longitude'] as num).toDouble(),
    address: data['address'],
  );

  Map<String, dynamic> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
  };

  factory LocationModel.fromEntity(LocationEntity location) {
    return LocationModel(
      latitude: location.latitude,
      longitude: location.longitude,
      address: location.address,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
    );
  }
}
