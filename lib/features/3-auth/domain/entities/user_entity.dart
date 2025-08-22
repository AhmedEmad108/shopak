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
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      lastLogin: DateTime.parse(map['lastLogin'] as String),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
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
}
