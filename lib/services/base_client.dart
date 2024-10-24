import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'app_exceptions.dart';

class BaseClient {
  static var client = http.Client();
  // ignore: constant_identifier_names
  static const int TIME_OUT_DURATION = 20;

  // GET
  Future<dynamic> get(String baseUrl, String api, dynamic headers) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Tidak terhubung dengan jaringan internet', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time', uri.toString());
    }
  }

  // GET WITHOUT HEADER
  Future<dynamic> getWOH(String baseUrl, String api, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await client
          .get(
            uri,
          )
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Tidak terhubung dengan jaringan internet', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time', uri.toString());
    }
  }

  // GET ONlY API
  Future<dynamic> getOA(String baseUrl, String api) async {
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await client
          .get(uri)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Tidak terhubung dengan jaringan internet', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time', uri.toString());
    }
  }

  // POST
  Future<dynamic> post(
      String baseUrl, String api, dynamic headers, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    try {
      var response = await client
          .post(uri, headers: headers, body: payloadObj)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Tidak terhubung dengan jaringan internet', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time', uri.toString());
    }
  }

// POST WITHOUT HEADER
  Future<dynamic> postWOH(
      String baseUrl, String api, dynamic payloadObj) async {
    var uri = Uri.parse(baseUrl + api);
    // var payload = json.encode(payloadObj);
    try {
      var response = await client
          .post(uri, body: payloadObj)
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Tidak terhubung dengan jaringan internet', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not responded in time', uri.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    final body = jsonDecode(response.body);
    // print(response.statusCode);
    // print(body);
    String result = "Tidak dapat diproses";
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.body;
      case 400:
        throw BadRequestException(
            response.body, response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(
            response.body, response.request!.url.toString());
      case 404:
      case 500:
      default:
        // if (body['message'] == 'An error has occurred.') {
        //   result = 'Terjadi kesalahan. Mohon coba lagi dalam beberapa saat.';
        // } else if (body['message'] == 'Not found') {
        //   result = 'Data tidak ditemukan';
        // } else if (body['message'] == 'Auth failed') {
        //   result = 'Autentikasi gagal';
        // } else if (body['message'] == 'Unit not found') {
        //   result = 'Maaf Unit tidak ditemukan.';
        // }
        result = 'status ${response.statusCode}\n ${body['message']}';
        throw FetchDataException(result, response.request!.url.toString());
    }
  }
}
