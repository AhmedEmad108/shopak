import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String uId;
  final String email;
  final String name;
  final String phone;
  final String image;
  final List<String>? address;
  final int? primaryIndex;
  final bool isActive;
  final bool isEmailVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastLogin;
  UserEntity({
    required this.uId,
    required this.email,
    required this.name,
    required this.phone,
    required this.image,
    this.address,
    this.primaryIndex,
    required this.isActive,
    required this.isEmailVerified,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
  });

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uId: map['uId'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      image: map['image'] as String,
      address: List<String>.from(map['address'] ?? []),
      primaryIndex: map['primaryIndex'] as int,
      isActive: map['isActive'] as bool,
      isEmailVerified: map['isEmailVerified'] as bool,
      role: map['role'] as String,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
      lastLogin: parseDate(map['lastLogin']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'email': email,
      'name': name,
      'phone': phone,
      'image': image,
      'address': address ?? [],
      'primaryIndex': primaryIndex,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
    };
  }

  UserEntity copyWith({
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
    return UserEntity(
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

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uId: json['uId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      image: json['image'],
      address: List<String>.from(json['address'] ?? []),
      primaryIndex: json['primaryIndex'],
      isActive: json['isActive'],
      isEmailVerified: json['isEmailVerified'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      lastLogin: json['lastLogin'],
    );
  }

  static DateTime parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
