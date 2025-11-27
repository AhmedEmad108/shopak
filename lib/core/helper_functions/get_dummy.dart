import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

UserEntity getDummyProduct() {
  return UserEntity(
    uId: '1',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    email: 'ahmedemad@gmail.com',
    name: 'Ahmed Emad',
    phone: '0123456789',
    image: 'https://picsum.photos/200',
    isActive: true,
    isEmailVerified: true,
    role: 'user',
    lastLogin: DateTime.now(),
  );
}

List<UserEntity> getDummyUsers() {
  return [
    getDummyProduct(),
    getDummyProduct(),
    getDummyProduct(),
    getDummyProduct(),
    getDummyProduct(),
  ];
}

// CategoryEntity getDummyCategory() {
//   return CategoryEntity(
//     id: '1',
//     urlImage: Platform.isAndroid
//         ? 'https://picsum.photos/200'
//         : 'https://picsum.photos/200',
//     categoryEn: 'Category 1',
//     categoryAr: 'القسم 1',
//     status: true,
//   );
// }

// List<CategoryEntity> getDummyCategories() {
//   return [
//     getDummyCategory(),
//     getDummyCategory(),
//     getDummyCategory(),
//     getDummyCategory(),
//     getDummyCategory(),
//   ];
// }
