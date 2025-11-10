import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl(this._supabase);

  @override
  Future<User> register(String email, String password, String name, int age) async {
    // Normalizar el email (trim, lowercase, sin espacios) - fuera del try para acceso en catch
    final normalizedEmail = email.trim().toLowerCase().replaceAll(' ', '');
    
    try {
      // Validación del email antes de enviarlo
      if (normalizedEmail.isEmpty) {
        throw Exception('El email no puede estar vacío');
      }
      
      // Validar formato de email
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      
      if (!emailRegex.hasMatch(normalizedEmail)) {
        throw Exception('El formato del email no es válido. Debe ser: usuario@ejemplo.com');
      }
      
      // Validar contraseña
      if (password.isEmpty || password.length < 6) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }
      
      // Validar nombre
      if (name.isEmpty || name.trim().isEmpty) {
        throw Exception('El nombre no puede estar vacío');
      }
      
      // Validar edad
      if (age < 3 || age > 12) {
        throw Exception('La edad debe estar entre 3 y 12 años');
      }
      
      print('📧 Intentando registrar usuario con email: $normalizedEmail');
      
      // Intentar registrar el usuario con opciones adicionales
      final response = await _supabase.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: {
          'name': name,
          'age': age,
        },
        emailRedirectTo: null, // No requerir confirmación de email por ahora
      );
      
      print('✅ Respuesta de signUp: user=${response.user != null}, session=${response.session != null}');

      // Verificar si hay un error en la respuesta
      if (response.session == null && response.user == null) {
        // Si hay un error, intentar obtener más información
        final errorMessage = response.toString();
        throw Exception('Error al crear el usuario. Verifica que el email no esté ya registrado. $errorMessage');
      }

      // Si el usuario se creó pero no hay sesión (confirmación de email requerida)
      if (response.user != null && response.session == null) {
        // El trigger en Supabase debería crear el registro automáticamente
        // Pero intentamos insertarlo manualmente por si acaso
        try {
          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': email,
            'name': name,
            'age': age,
            'created_at': DateTime.now().toIso8601String(),
          });
        } catch (insertError) {
          // Si falla, esperamos un momento y verificamos si el trigger lo creó
          await Future.delayed(const Duration(seconds: 1));
          try {
            final existingUser = await _supabase
                .from('users')
                .select()
                .eq('id', response.user!.id)
                .single();
            return User.fromJson(existingUser);
          } catch (e) {
            // Si aún no existe, puede ser que necesite confirmación de email
            print('⚠️ Usuario creado pero necesita confirmación de email');
            print('💡 Verifica tu email o desactiva la confirmación en Supabase');
          }
        }

        // Devolver el usuario aunque no haya sesión
        return User(
          id: response.user!.id,
          email: normalizedEmail,
          name: name,
          age: age,
          createdAt: DateTime.now(),
        );
      }

      // Si hay sesión, el usuario se creó correctamente
      if (response.user != null && response.session != null) {
        print('✅ Usuario creado correctamente con sesión');
        
        // Guardar información adicional del usuario
        try {
          await _supabase.from('users').insert({
            'id': response.user!.id,
            'email': normalizedEmail,
            'name': name,
            'age': age,
            'created_at': DateTime.now().toIso8601String(),
          });
          print('✅ Información del usuario guardada en la tabla users');
        } catch (insertError) {
          // Si falla, puede ser un problema de RLS, el usuario ya existe (409 Conflict),
          // o el trigger ya lo creó
          final errorString = insertError.toString();
          
          // Error 409 (Conflict) significa que el usuario ya existe (probablemente el trigger lo creó)
          if (errorString.contains('409') || 
              errorString.contains('Conflict') ||
              errorString.contains('duplicate key') ||
              errorString.contains('23505')) {
            print('✅ Usuario ya existe en la tabla (probablemente creado por trigger)');
            // Intentar obtener el usuario existente
            try {
              await Future.delayed(const Duration(milliseconds: 500)); // Esperar un momento
              final existingUser = await _supabase
                  .from('users')
                  .select()
                  .eq('id', response.user!.id)
                  .single();
              print('✅ Usuario encontrado en la tabla users');
              return User.fromJson(existingUser);
            } catch (e) {
              print('⚠️ No se pudo obtener usuario existente, creando objeto User manualmente');
              // Si no existe aún, crear el objeto User manualmente
              // El trigger debería crearlo pronto
              return User(
                id: response.user!.id,
                email: normalizedEmail,
                name: name,
                age: age,
                createdAt: DateTime.now(),
              );
            }
          } else {
            print('⚠️ Error al insertar en users: $insertError');
            // Para otros errores, intentar obtener el usuario existente
            try {
              final existingUser = await _supabase
                  .from('users')
                  .select()
                  .eq('id', response.user!.id)
                  .single();
              print('✅ Usuario encontrado en la tabla users');
              return User.fromJson(existingUser);
            } catch (e) {
              print('⚠️ No se pudo obtener usuario, usando datos de sesión');
              // Si no existe, crear el objeto User manualmente
              return User(
                id: response.user!.id,
                email: normalizedEmail,
                name: name,
                age: age,
                createdAt: DateTime.now(),
              );
            }
          }
        }

        return User(
          id: response.user!.id,
          email: normalizedEmail,
          name: name,
          age: age,
          createdAt: DateTime.now(),
        );
      }

      throw Exception('Error desconocido al crear el usuario');
    } on AuthException catch (e) {
      // Manejar errores específicos de autenticación
      print('❌ AuthException: ${e.message}');
      print('❌ Status Code: ${e.statusCode}');
      
      String errorMessage = 'Error en el registro';
      
      if (e.message.toLowerCase().contains('already registered') || 
          e.message.toLowerCase().contains('already exists') ||
          e.message.toLowerCase().contains('user already registered')) {
        errorMessage = 'Este email ya está registrado. Por favor, inicia sesión.';
      } else if (e.message.toLowerCase().contains('invalid') || 
                 e.message.toLowerCase().contains('format') ||
                 e.message.toLowerCase().contains('email')) {
        errorMessage = 'El formato del email no es válido. Asegúrate de usar un formato como: usuario@ejemplo.com';
      } else if (e.message.toLowerCase().contains('password') ||
                 e.message.toLowerCase().contains('weak')) {
        errorMessage = 'La contraseña no cumple con los requisitos. Debe tener al menos 6 caracteres.';
      } else if (e.statusCode == '400') {
        errorMessage = 'Error en el registro. Verifica que:\n- El email sea válido (ej: usuario@ejemplo.com)\n- La contraseña tenga al menos 6 caracteres\n- El email no esté ya registrado';
      } else {
        errorMessage = 'Error en el registro: ${e.message}';
      }
      
      throw Exception(errorMessage);
    } catch (e) {
      // Manejar otros errores
      final errorString = e.toString();
      print('❌ Error completo en registro: $errorString');
      print('❌ Tipo de error: ${e.runtimeType}');
      
      // Si el error contiene información sobre el email
      if (errorString.toLowerCase().contains('already registered') || 
          errorString.toLowerCase().contains('already exists') ||
          errorString.toLowerCase().contains('user already registered')) {
        throw Exception('Este email ya está registrado. Por favor, inicia sesión.');
      } else if (errorString.toLowerCase().contains('invalid email') ||
                 errorString.toLowerCase().contains('email format') ||
                 errorString.toLowerCase().contains('email validation')) {
        throw Exception('El formato del email no es válido. Debe ser: usuario@ejemplo.com\nEmail intentado: $normalizedEmail');
      } else if (errorString.toLowerCase().contains('password') ||
                 errorString.toLowerCase().contains('weak password')) {
        throw Exception('La contraseña debe tener al menos 6 caracteres.');
      } else if (errorString.contains('400')) {
        throw Exception('Error 400: Solicitud inválida.\nVerifica que el email sea válido y la contraseña tenga al menos 6 caracteres.\nEmail: $normalizedEmail');
      } else {
        // Mostrar el error completo para debugging
        final cleanError = errorString.length > 200 
            ? '${errorString.substring(0, 200)}...' 
            : errorString;
        throw Exception('Error en el registro: $cleanError');
      }
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Error al iniciar sesión');
      }

      // Obtener información del usuario
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return User.fromJson(userData);
    } catch (e) {
      throw Exception('Error en el login: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) return null;

      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', session.user.id)
          .single();

      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _supabase.auth.currentSession != null;
  }
}

