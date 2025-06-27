import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_auth_service.dart';

class MockAuthNotifier extends StateNotifier<AsyncValue<MockUser?>> {
  MockAuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  final _authService = MockAuthService();

  void _init() {
    state = const AsyncValue.data(null);
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.signIn(email, password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String role = 'user',
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final mockAuthProvider = StateNotifierProvider<MockAuthNotifier, AsyncValue<MockUser?>>(
  (ref) => MockAuthNotifier(),
);