import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSource({required this.sharedPreferences});

  static const String key = 'cached_users';

  Future<void> cacheUsers(List<UserModel> users) async {
    final List<String> jsonStringList = users.map((u) => json.encode(u.toJson())).toList();
    await sharedPreferences.setStringList(key, jsonStringList);
  }

  Future<List<UserModel>> getCachedUsers() async {
    final List<String>? jsonStringList = sharedPreferences.getStringList(key);
    if (jsonStringList != null && jsonStringList.isNotEmpty) {
      return jsonStringList.map((s) => UserModel.fromJson(json.decode(s))).toList();
    }
    return [];
  }
}
