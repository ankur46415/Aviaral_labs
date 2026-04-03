import '../../../core/constants/api_constants.dart';
import 'package:dio/dio.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource({required this.dio});

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await dio.get(ApiConstants.usersUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      print('DEBUG: UserRemoteDataSource Error: $e');
      if (e is DioException) {
        print('DEBUG: Dio Error Type: ${e.type}');
        print('DEBUG: Dio Error Message: ${e.message}');
        print('DEBUG: Dio Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
