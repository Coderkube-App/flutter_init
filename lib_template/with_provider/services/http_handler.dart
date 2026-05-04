import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider_project/config/constant.dart';
import 'package:provider_project/services/api_end_points.dart';


class HttpHandler {
  static String? token;

  static Future<bool> _hasNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  // Retrieve the headers for the HTTP request
  static Future<Map<String, String>> getHeaders() async {
    appPrint("Token in Package:: $token");

    if (token != "null" || token != "") {
      appPrint("Token -- '$token'");
      return {
        // 'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } else {
      return {
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      };
    }
  }

  // Perform an HTTP GET request
  static Future<Map<String, dynamic>> getHttpMethod(
      {required String? url}) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }

    var header = await getHeaders();
    appPrint("Get URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Get Data -- 'null'");
    appPrint("Get Header -- '$header'");
    http.Response response = await http.get(
      Uri.parse("${APIEndPoints.baseUrl}$url"),
      headers: header,
    );
    appPrint("Get Response Code -- '${response.statusCode}'");
    appPrint("Get Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      appPrint("In Get '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      appPrint("In Get 'else - ${response.statusCode}");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    } else {
      appPrint("In Get 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  // Perform an HTTP POST request
  static Future<Map<String, dynamic>> postHttpMethod({
    required String? url,
    Map<String, dynamic>? data,
  }) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }

    var header = await getHeaders();
    appPrint("Post URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Post Data -- '$data'");
    appPrint("Post Header -- '$header'");
    http.Response response = await http.post(
      Uri.parse("${APIEndPoints.baseUrl}$url"),
      headers: header,
      body: data ?? {},
    );
    appPrint("Post Response Code -- '${response.statusCode}'");
    appPrint("Post Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
    } else if (response.statusCode == 401) {
      appPrint("In Get 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    } else if (response.statusCode == 402) {
      // discaSnackBar(message: "Session expired. Please Login again.");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    } else {
      appPrint("In Post 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  // Perform an HTTP PATCH request
  static Future<Map<String, dynamic>> patchHttpMethod(
      {@required String? url, Map<String, dynamic>? data}) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }
    var header = await getHeaders();
    appPrint("Patch URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Patch Data -- '$data'");
    appPrint("Patch Header -- '$header'");
    http.Response response = await http.patch(
      Uri.parse("${APIEndPoints.baseUrl}$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    appPrint("Patch Response Code -- '${response.statusCode}'");
    appPrint("Patch Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      appPrint("In Patch '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      appPrint("In Get 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    } else {
      appPrint("In Patch 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  // Perform an HTTP PUT request
  static Future<Map<String, dynamic>> putHttpMethod(
      {@required String? url, Map<String, dynamic>? data}) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }
    var header = await getHeaders();
    appPrint("Put URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Put Data -- '$data'");
    appPrint("Put Header -- '$header'");
    http.Response response = await http.put(
      Uri.parse("${APIEndPoints.baseUrl}$url"),
      headers: header,
      body: data == null ? null : jsonEncode(data),
    );
    appPrint("PUT Response code -- '${response.statusCode}'");
    appPrint("PUT Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      appPrint("In Put '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      appPrint("In Get 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    } else {
      appPrint("In Put 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

  // Perform an HTTP DELETE request
  static Future<Map<String, dynamic>> deleteHttpMethod(
      {@required String? url}) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }
    var header = await getHeaders();
    appPrint("Delete URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Delete Data -- 'null'");
    appPrint("Delete Header -- '$header'");
    http.Response response = await http.delete(
      Uri.parse("${APIEndPoints.baseUrl}$url"),
      headers: header,
    );
    appPrint("Delete Response Code -- '${response.statusCode}'");
    appPrint("Delete Response -- '${response.body}'");
    if (response.statusCode == 200 || response.statusCode == 201) {
      appPrint("In Delete '${response.statusCode}'");
      Map<String, dynamic> data = {
        'body': response.body,
        'headers': response.headers,
        'error': null,
      };
      return data;
    } else if (response.statusCode == 401) {
      appPrint("In Get 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    } else {
      appPrint("In Delete 'else - ${response.statusCode}'");
      return {
        'body': response.body,
        'headers': response.headers,
        'error': "${response.statusCode}",
      };
    }
  }

//Method Type = POST, GET
  static Future<Map<String, dynamic>> formHttpMethod(
      {@required String? methodType,
        @required String? url,
        Map<String, String>? data,
        File? singleFile,
        File? singleFile2,
        String? singleFileKey,
        String? singleFileKey2,
        List<File?>? multipleFile,
        List<String>? multipleFileKeysList,
        List<File?>? multipleFile2,
        List<String>? multipleFileKeysList2,
        String? multipleFileKey,
        String? multipleFileKey2
      }) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }
    var header = await getHeaders();
    appPrint("Form URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Form Header -- '$header'");
    http.MultipartRequest request =
    http.MultipartRequest(methodType!, Uri.parse("${APIEndPoints.baseUrl}$url"));
    request.headers.addAll(header);
    if (data != null) {
      request.fields.addAll(data);
      appPrint("DATA--------------->$data");
    }
    appPrint("Single File Data:: $singleFile");
    if (singleFile != null) {
      appPrint("Single File Data 1");
      request.files.add(await http.MultipartFile.fromPath(
        singleFileKey!,
        singleFile.path,
      ));
      appPrint("FORM FILES - ${request.files.first.filename}");
    }
    if (singleFile2 != null) {
      appPrint("Single File Data 2");
      request.files.add(await http.MultipartFile.fromPath(
        singleFileKey2!,
        singleFile2.path,
      ));
      appPrint("FORM FILES 2 - ${request.files.first.filename}");
    }
    appPrint("Single File Data 2");

    // if (multipleFileKey != null) {
    //   if (multipleFileKeysList != null) {
    //     if (multipleFileKeysList.isNotEmpty) {
    //       for (var i = 0; i < multipleFile!.length; i++) {
    //         request.files.add(await http.MultipartFile.fromPath(
    //             multipleFileKeysList[i], multipleFile[i]?.path ?? ""));
    //       }
    //     }
    //   } else {
    //     if (multipleFile!.isNotEmpty) {
    //       for (int i = 0; i < multipleFile.length; i++) {
    //         File element = multipleFile[i]!;
    //         request.files.add(await http.MultipartFile.fromPath(
    //           multipleFileKey,
    //           element.path,
    //         ));
    //       }
    //     }
    //   }
    // }
    if (multipleFileKey != null && multipleFile != null && multipleFile.isNotEmpty) {
      for (int i = 0; i < multipleFile.length; i++) {
        if (multipleFile[i] != null) {
          request.files.add(await http.MultipartFile.fromPath(
            multipleFileKey, // Use the key directly
            multipleFile[i]!.path,
          ));
        }
      }
    }


    // if (multipleFileKey2 != null) {
    //   if (multipleFileKeysList2 != null) {
    //     if (multipleFileKeysList2.isNotEmpty) {
    //       for (var i = 0; i < multipleFile2!.length; i++) {
    //         request.files.add(await http.MultipartFile.fromPath(
    //             multipleFileKeysList2[i], multipleFile2[i]?.path ?? ""));
    //       }
    //     }
    //   } else {
    //     if (multipleFile2!.isNotEmpty) {
    //       for (int i = 0; i < multipleFile2.length; i++) {
    //         File element = multipleFile2[i]!;
    //         request.files.add(await http.MultipartFile.fromPath(
    //           multipleFileKey2,
    //           element.path,
    //         ));
    //       }
    //     }
    //   }
    // }
    if (multipleFileKey2 != null && multipleFile2 != null && multipleFile2.isNotEmpty) {
      for (int i = 0; i < multipleFile2.length; i++) {
        if (multipleFile2[i] != null) {
          request.files.add(await http.MultipartFile.fromPath(
            multipleFileKey2, // Use the key directly
            multipleFile2[i]!.path,
          ));
        }
      }
    }
    appPrint("FORM FIELDS - ${request.fields}");
    appPrint("FORM FILES - ${request.files}");

    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 201) {
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        appPrint("In Post '${response.statusCode}'");
        appPrint("FORM RESPONSE -- '${response.body}'");
        // int status = json.decode(response.body)["status"];
        Map<String, dynamic> data;
        data = {
          'body': response.body,
          'headers': response.headers,
          'error': null,
        };
        return data;
      } else if (response.statusCode == 401) {
        appPrint("In Get 'else - ${response.statusCode}'");
        return {
          'body': response.body,
          'headers': response.headers,
          'error': "${response.statusCode}",
        };
      } else {
        appPrint("In Form 'else 3 - ${response.statusCode}'");
        return {
          'body': response.body,
          'headers': response.headers,
          'error': "${response.statusCode}",
        };
      }
    } else {
      http.Response response1 =
      await http.Response.fromStream(streamedResponse);
      appPrint("In Form 'else 1---- ${streamedResponse.statusCode}'");
      return {
        'body': response1.body,
        'headers': response1.headers,
        'error': "${response1.statusCode}",
      };
    }
  }

  //Method Type = POST, GET
  static Future<Map<String, dynamic>> formHttpMethodPlatFormFile(
      {@required String? methodType,
        @required String? url,
        Map<String, String>? data,
        PlatformFile? singleFile,
        // File? singleFile2,
        String? singleFileKey,
        // String? singleFileKey2,
        List<PlatformFile>? multipleFile,
        List<String>? multipleFileKeysList,
        String? multipleFileKey}) async {
    if (!(await _hasNetwork())) {
      return {
        'body': null,
        'headers': null,
        'error': "No network available",
      };
    }
    var header = await getHeaders();
    appPrint("Form URL -- '${APIEndPoints.baseUrl}$url'");
    appPrint("Form Header -- '$header'");
    http.MultipartRequest request =
    http.MultipartRequest(methodType!, Uri.parse("${APIEndPoints.baseUrl}$url"));
    request.headers.addAll(header);
    if (data != null) {
      request.fields.addAll(data);
    }
    if (singleFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        singleFileKey!,
        singleFile.path!,
      ));
    }

    if (multipleFileKey != null) {
      if (multipleFileKeysList != null) {
        if (multipleFileKeysList.isNotEmpty) {
          for (var i = 0; i < multipleFile!.length; i++) {
            request.files.add(await http.MultipartFile.fromPath(
                multipleFileKeysList[i], multipleFile[i].path!));
          }
        }
      } else {
        if (multipleFile!.isNotEmpty) {
          for (PlatformFile element in multipleFile) {
            request.files.add(await http.MultipartFile.fromPath(
              multipleFileKey,
              element.path!,
            ));
          }
        }
      }
    }

    appPrint("FORM FIELDS - ${request.fields}");
    appPrint("FORM FILES - ${request.files.first.filename}");
    http.StreamedResponse streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 201) {
      http.Response response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        appPrint("In Post '${response.statusCode}'");
        appPrint("FORM RESPONSE -- '${response.body}'");
        // int status = json.decode(response.body)["status"];
        Map<String, dynamic> data;
        data = {
          'body': response.body,
          'headers': response.headers,
          'error': null,
        };
        return data;
      } else if (response.statusCode == 401) {
        appPrint("In Get 'else - ${response.statusCode}'");
        return {
          'body': response.body,
          'headers': response.headers,
          'error': "${response.statusCode}",
        };
      } else {
        appPrint("In Form 'else 3 - ${response.statusCode}'");
        return {
          'body': response.body,
          'headers': response.headers,
          'error': "${response.statusCode}",
        };
      }
    } else {
      http.Response response1 =
      await http.Response.fromStream(streamedResponse);
      appPrint("In Form 'else 1---- ${streamedResponse.statusCode}'");
      return {
        'body': response1.body,
        'headers': response1.headers,
        'error': "${response1.statusCode}",
      };
    }
  }
}
