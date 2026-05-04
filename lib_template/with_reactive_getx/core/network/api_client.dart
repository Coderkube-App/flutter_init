import 'dart:convert';

import 'package:flutter_with_reactive_getx/core/network/api_endpoints.dart';
import 'package:flutter_with_reactive_getx/core/utils/app_logger.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(Uri.parse('${ApiEndpoints.baseUrl}$path'));
    appLog('GET $path => ${response.statusCode}');
    return _mapResponse(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}$path'),
      body: jsonEncode(body),
      headers: {'content-type': 'application/json'},
    );
    appLog('POST $path => ${response.statusCode}');
    return _mapResponse(response);
  }

  Map<String, dynamic> _mapResponse(http.Response response) {
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'headers': response.headers,
    };
  }
}
