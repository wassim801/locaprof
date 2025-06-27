import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UserNotifier() : super(const AsyncValue.loading());

  void setUser(UserModel user) {
    state = AsyncValue.data(user);
  }

  void updateUser({
    String? displayName,
    String? email,
    String? photoUrl,
  }) {
    state.whenData((currentUser) {
      if (currentUser != null) {
        state = AsyncValue.data(
          currentUser.copyWith(
            displayName: displayName,
            email: email,
            photoUrl: photoUrl,
          ),
        );
      }
    });
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }

  Future<void> refreshUser() async {
    // TODO: Implement user data refresh from backend
    // This would typically involve fetching fresh user data from your backend
    try {
      state = const AsyncValue.loading();
      // Add API call here to fetch updated user data
      // final updatedUser = await userRepository.getCurrentUser();
      // state = AsyncValue.data(updatedUser);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>(
  (ref) => UserNotifier(),
);