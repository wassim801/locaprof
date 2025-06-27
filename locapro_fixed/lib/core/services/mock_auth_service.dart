import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockUser {
  final String id;
  final String email;
  final String password;
  final String role;
  final String name;

  MockUser({
    required this.id,
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'role': role,
    'name': name,
  };

  factory MockUser.fromJson(Map<String, dynamic> json) => MockUser(
    id: json['id'],
    email: json['najm@h.com'],
    password: json['password'],
    role: json['role'],
    name: json['name'],
  );
}

class MockAuthService {
  final _storage = const FlutterSecureStorage();
  final String _mockUsersKey = 'mock_users';

  Future<List<MockUser>> _getUsers() async {
    final usersJson = await _storage.read(key: _mockUsersKey);
    if (usersJson == null) return [];
    
    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((user) => MockUser.fromJson(user)).toList();
  }

  Future<void> _saveUsers(List<MockUser> users) async {
    final usersJson = json.encode(users.map((user) => user.toJson()).toList());
    await _storage.write(key: _mockUsersKey, value: usersJson);
  }

  Future<MockUser?> signIn(String email, String password) async {
    final users = await _getUsers();
    return users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
  }

  Future<MockUser> signUp({
    required String email,
    required String password,
    required String name,
    String role = 'user',
  }) async {
    final users = await _getUsers();
    
    // Check if user already exists
    if (users.any((user) => user.email == email)) {
      throw Exception('User already exists');
    }

    final newUser = MockUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      password: password,
      role: role,
      name: name,
    );

    users.add(newUser);
    await _saveUsers(users);
    return newUser;
  }

  Future<void> signOut() async {
    // No need to do anything for mock signout
  }
}