import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roaster/src/data/const.data.dart';
import 'package:roaster/src/services/state/state.service.dart';

ConstData cd = ConstData();

String _baseUrl = cd.getBaseUrl;

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: _baseUrl),
  );

  // Login
  Future<Response> login(dynamic data) async {
    Response response;

    try {
      response = await _dio.post('/auth/login', data: data);

      return response;
    } on DioException catch (e) {
      response = e.response!;

      return response;
    }
  }

  // Change user info
  Future<Response> updateUser(
    String id,
    dynamic data,
    BuildContext context,
  ) async {
    Response response;

    String token = Provider.of<AppState>(context, listen: false).getToken;

    _dio.options.headers["Authorization"] = 'Bearer $token';

    try {
      response = await _dio.patch('/users/$id', data: data);

      return response;
    } on DioException catch (e) {
      response = e.response!;

      return response;
    }
  }

  // Change user password
  Future<Response> updateUserPassword(
    String id,
    dynamic data,
    BuildContext context,
  ) async {
    Response response;

    String token = Provider.of<AppState>(context, listen: false).getToken;

    _dio.options.headers["Authorization"] = 'Bearer $token';

    try {
      response = await _dio.patch('/users/password/$id', data: data);

      return response;
    } on DioException catch (e) {
      response = e.response!;

      return response;
    }
  }

  // Get All Tickets
  Future<Response> allTickets(BuildContext context) async {
    Response response;

    String token = Provider.of<AppState>(context, listen: false).getToken;

    _dio.options.headers["Authorization"] = 'Bearer $token';

    try {
      response = await _dio.get('/support');

      return response;
    } on DioException catch (e) {
      response = e.response!;

      return response;
    }
  }

  // Get Single Ticket
  Future<Response> singleTicket(String id, BuildContext context) async {
    Response response;

    String token = Provider.of<AppState>(context, listen: false).getToken;

    _dio.options.headers["Authorization"] = 'Bearer $token';

    try {
      response = await _dio.get('/support/$id');

      return response;
    } on DioException catch (e) {
      response = e.response!;

      return response;
    }
  }

  // Create Ticket
  Future<Response> createTicket(dynamic data, BuildContext context) async {
    Response response;

    String token = Provider.of<AppState>(context, listen: false).getToken;

    _dio.options.headers["Authorization"] = 'Bearer $token';

    try {
      response = await _dio.post('/support', data: data);

      return response;
    } on DioException catch (e) {
      response = e.response!;

      return response;
    }
  }
}
