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
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      location: json['location'] != null
          ? LocationModel.fromMap(json['location'])
          : null,
      isEmailVerified: json['isEmailVerified'],
      isLocationSelected: json['isLocationSelected'],
      isProfileCompleted: json['isProfileCompleted'],
      userType: json['userType'],
    );
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
}
