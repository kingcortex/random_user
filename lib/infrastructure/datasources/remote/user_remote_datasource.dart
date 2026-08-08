import 'package:random_user/infrastructure/models/users_response_model.dart';

abstract class UserRemoteDataSource {
  Future<UsersResponseModel> fetchPage({
    required int page,
    required int results,
  });
}
