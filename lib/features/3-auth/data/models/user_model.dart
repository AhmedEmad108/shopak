import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uId,
    required super.email,
    required super.name,
    required super.phone,
    required super.image,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uId: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      image: user.photoURL ?? '',
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      image: map['image'],
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uId: user.uId,
      email: user.email,
      name: user.name,
      phone: user.phone,
      image: user.image,
    );
  }

  toMap() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'phone': phone,
      'image': image,
    };
  }
}
