import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/error/exceptions.dart';

// MOCK statistics data - outside the class
final Map<String, dynamic> mockStatistics = {
  'totalProperties': 10,
  'rentedProperties': 6,
  'availableProperties': 4,
  'totalMonthlyIncome': 5600,
  'propertyTypes': {
    'appartement': 5,
    'maison': 2,
    'studio': 2,
    'villa': 1,
  }
};

// A mock Riverpod provider for stats
final mockPropertyStatsProvider = StateProvider<Map<String, dynamic>>((ref) {
  return mockStatistics;
});

class PropertyProvider extends StateNotifier<AsyncValue<List<PropertyModel>>> {
  final TokenService _tokenService;
  final http.Client _client;

  PropertyProvider({
    required TokenService tokenService,
    required http.Client client,
  })  : _tokenService = tokenService,
        _client = client,
        super(const AsyncValue.loading());

  Future<void> loadProperties() async {
    try {
      final token = await _tokenService.getToken();
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.properties}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body)['data'];
        final properties = jsonList.map((json) => PropertyModel.fromJson(json)).toList();
        state = AsyncValue.data(properties);
      } else {
        throw ApiException(
          message: json.decode(response.body)['message'] ?? 'Failed to load properties',
          statusCode: response.statusCode,
        );
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addProperty(PropertyModel property) async {
    try {
      state = const AsyncValue.loading();
      final token = await _tokenService.getToken();
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.properties}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(property.toJson()),
      );

      if (response.statusCode == 201) {
        await loadProperties();
      } else {
        throw ApiException(
          message: json.decode(response.body)['message'] ?? 'Failed to add property',
          statusCode: response.statusCode,
        );
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProperty(String id, PropertyModel property) async {
    try {
      state = const AsyncValue.loading();
      final token = await _tokenService.getToken();
      final response = await _client.put(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.properties}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(property.toJson()),
      );

      if (response.statusCode == 200) {
        await loadProperties();
      } else {
        throw ApiException(
          message: json.decode(response.body)['message'] ?? 'Failed to update property',
          statusCode: response.statusCode,
        );
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      state = const AsyncValue.loading();
      final token = await _tokenService.getToken();
      final response = await _client.delete(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.properties}/$propertyId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await loadProperties();
      } else {
        throw ApiException(
          message: json.decode(response.body)['message'] ?? 'Failed to delete property',
          statusCode: response.statusCode,
        );
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<Map<String, dynamic>> getPropertyStatistics() async {
    try {
      final token = await _tokenService.getToken();
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.properties}/statistics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      } else {
        throw ApiException(
          message: json.decode(response.body)['message'] ?? 'Failed to get statistics',
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      throw error;
    }
  }
}
