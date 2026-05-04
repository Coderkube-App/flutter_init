
import 'dart:convert';

import 'package:my_real_app/services/api_end_points.dart';
import 'package:my_real_app/services/http_handler.dart';


class AuthRepo{
  /// login Api
  static Future login({required Map<String, dynamic> body}) async {
    await HttpHandler.postHttpMethod(url: APIEndPoints.loginAPIUIrl, data: body).then((value) {
      if (value['error'] == null) {
        var jsonMap = json.decode(value['body']);
        return jsonMap;
      } else if (value['error'] == "No network available"){
        return null;
      } else {
        return null;
      }
    });
  }

  /// get profile Api
  static Future getProfile() async {
    await HttpHandler.getHttpMethod(url: APIEndPoints.getProfileUrl).then((value) {
      if (value['error'] == null) {
        var jsonMap = json.decode(value['body']);
        return jsonMap;
      } else if (value['error'] == "No network available"){
        return null;
      } else {

        return null;
      }
    });
  }



}