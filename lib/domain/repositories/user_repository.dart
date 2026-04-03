import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> fetchUsers();
  Future<List<UserEntity>> getCachedUsers();
  Future<void> cacheUsers(List<UserEntity> users);
}
