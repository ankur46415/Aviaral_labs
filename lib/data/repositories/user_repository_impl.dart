import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';
import '../sources/local/user_local_datasource.dart';
import '../sources/remote/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<UserEntity>> fetchUsers() async {
    try {
      final List<UserModel> remoteUsers = await remoteDataSource.fetchUsers();
      await cacheUsers(remoteUsers);
      return remoteUsers;
    } catch (e) {
      final List<UserEntity> cachedUsers = await getCachedUsers();
      if (cachedUsers.isNotEmpty) {
        return cachedUsers;
      }
      rethrow;
    }
  }

  @override
  Future<List<UserEntity>> getCachedUsers() async {
    return await localDataSource.getCachedUsers();
  }

  @override
  Future<void> cacheUsers(List<UserEntity> users) async {
    await localDataSource.cacheUsers(users.map((u) => UserModel(
      id: u.id,
      name: u.name,
      email: u.email,
      phone: u.phone,
      website: u.website,
      address: u.address,
    )).toList());
  }
}
