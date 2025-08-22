import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uId,
    required super.email,
    required super.name,
    required super.phone,
    required super.image,
    super.address,
    super.primaryIndex,
    required super.isActive,
    required super.isEmailVerified,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
    required super.lastLogin,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uId: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      image: user.photoURL ?? '',
      address: [],
      primaryIndex: 0,
      isActive: true,
      isEmailVerified: user.emailVerified,
      role: 'user',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uId: map['uId'],
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      image: map['image'],
      address: map['address'] != null ? List<String>.from(map['address']) : [],
      primaryIndex: map['primaryIndex'] ?? 0,
      isActive: map['isActive'] ?? true,
      isEmailVerified: map['isEmailVerified'] ?? false,
      role: map['role'] ?? 'user',
      createdAt: fromTimestamp(map['createdAt']),
      updatedAt: fromTimestamp(map['updatedAt']),
      lastLogin: fromTimestamp(map['lastLogin']),
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      uId: user.uId,
      email: user.email,
      name: user.name,
      phone: user.phone,
      image: user.image,
      address: user.address,
      primaryIndex: user.primaryIndex,
      isActive: user.isActive,
      isEmailVerified: user.isEmailVerified,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      lastLogin: user.lastLogin,
    );
  }

  @override
  toMap() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'phone': phone,
      'image': image,
      'address': address,
      'primaryIndex': primaryIndex,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  @override
  UserModel copyWith({
    String? uId,
    String? email,
    String? name,
    String? phone,
    String? image,
    List<String>? address,
    int? primaryIndex,
    bool? isActive,
    bool? isEmailVerified,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      uId: uId ?? this.uId,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      address: address ?? this.address,
      primaryIndex: primaryIndex ?? this.primaryIndex,
      isActive: isActive ?? this.isActive,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  /// 🟡 Helper: للتعامل مع Firestore Timestamp أو String ISO
  static DateTime fromTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
