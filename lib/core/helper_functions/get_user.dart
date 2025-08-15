import 'dart:convert';

import 'package:shopak/contants.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/features/3-auth/data/models/user_model.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

UserEntity getUser() {
  var jsonString = Prefs.getString(kUserData);
  var userEntity = UserModel.fromJson(jsonDecode(jsonString));
  return userEntity;
}
