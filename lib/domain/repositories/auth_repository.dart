import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> register(String email, String password, String name, int age);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}




