import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/users_response.dart';

import 'page_info_model.dart';
import 'user_model.dart';

final class UsersResponseModel {
  const UsersResponseModel({required this.users, required this.info});

  factory UsersResponseModel.fromJson(JsonMap json) => UsersResponseModel(
        users: dynParser<List<JsonMap>>(json['results'])
            .map(UserModel.fromJson)
            .toList(),
        info: PageInfoModel.fromDyn(json['info']),
      );

  Map<String, dynamic> toJson() => {
        'results': users.map((u) => u.toJson()).toList(),
        'info': info.toJson(),
      };

  UsersResponse toEntity() => UsersResponse(
        users: users.map((u) => u.toEntity()).toList(),
        info: info.toEntity(),
      );

  final List<UserModel> users;
  final PageInfoModel info;
}
