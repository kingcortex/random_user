import 'package:random_user/core/network/api_endpoints.dart';
import 'package:random_user/core/network/client.dart';
import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/infrastructure/datasources/remote/user_remote_datasource.dart';
import 'package:random_user/infrastructure/models/users_response_model.dart';

final class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl({required this.client});

  final HttpClient client;

  @override
  Future<UsersResponseModel> fetchPage({
    required int page,
    required int results,
  }) async {
    final response = await client.get<JsonMap>(
      endpoint: ApiEndpoints.users,
      queryParameters: {'page': page, 'results': results},
    );
    return UsersResponseModel.fromJson(response);
  }
}
