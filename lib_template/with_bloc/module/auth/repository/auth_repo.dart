import 'dart:convert';

import 'package:bloc_project/services/api_end_points.dart';
import 'package:bloc_project/services/http_handler.dart';


class AuthRepo {
  /// login Api
  Future<dynamic> login({required Map<String, dynamic> body}) async {
    final value = await HttpHandler.postHttpMethod(
      url: APIEndPoints.loginAPIUrl,
      data: body,
    );

    if (value['error'] == null) {
      return json.decode(value['body']);
    } else {
      return null;
    }
  }

  /// get profile Api
  Future<dynamic> getProfile() async {
    final value = await HttpHandler.getHttpMethod(
      url: APIEndPoints.getProfileUrl,
    );

    if (value['error'] == null) {
      return json.decode(value['body']);
    } else {
      return null;
    }
  }
}
