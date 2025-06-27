import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/token_service.dart';
import '../error/exceptions.dart';
import '../constants/api_constants.dart';

class NetworkHelper {
  final http.Client client;
  final TokenService tokenService;

  NetworkHelper(this.client, this.tokenService);

  Future<Map<String, String>> _getHeaders() async {
    final token = await tokenService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(),
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, {dynamic body}) async {
    try {
      final response = await client.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(),
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    final body = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    if (response.statusCode == 401) {
      tokenService.deleteTokens(); // Clear tokens on unauthorized
    }

    throw ApiException(
      message: body['message'] ?? 'Une erreur s\'est produite',
      statusCode: response.statusCode,
      data: body['data'],
    );
  }

  Never _handleError(dynamic error) {
    if (error is ApiException) {
      throw error;
    }

    throw NetworkException(
      message: 'Erreur de connexion: ${error.toString()}',
    );
  }
}