import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/token_service.dart';
import '../../features/proprietaire/data/providers/property_provider.dart';
import '../../features/proprietaire/data/models/property_model.dart';
// Services providers
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(const FlutterSecureStorage(), storage: null);
});

final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

// Global state providers
final loadingProvider = StateProvider<bool>((ref) => false);

class AppError {
  final String message;
  final dynamic details;

  AppError({required this.message, this.details});
}

final errorProvider = StateProvider<AppError?>((ref) => null);

// Property providers
final propertyProvider = StateNotifierProvider<PropertyProvider, AsyncValue<List<PropertyModel>>>((ref) {
  final tokenService = ref.watch(tokenServiceProvider);
  final client = ref.watch(httpClientProvider);
  return PropertyProvider(tokenService: tokenService, client: client);
});

final propertyStatsProvider = StateProvider<Map<String, dynamic>>((ref) => {});