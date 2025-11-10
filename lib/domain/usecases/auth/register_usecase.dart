import '../../repositories/auth_repository.dart';
import '../../entities/user.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<User> execute(String email, String password, String name, int age) async {
    if (age < 3 || age > 12) {
      throw Exception('La edad debe estar entre 3 y 12 años');
    }
    return await repository.register(email, password, name, age);
  }
}




