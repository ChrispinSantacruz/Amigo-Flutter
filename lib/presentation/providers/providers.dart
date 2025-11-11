// Providers de dependencias
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/ai_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/chat/send_message_usecase.dart';
import '../../domain/usecases/chat/get_messages_usecase.dart';

// Supabase Client
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// AI Service
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

// Repositories
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepositoryImpl(supabase);
});

final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final aiService = ref.watch(aiServiceProvider);
  return ChatRepositoryImpl(supabase, aiService);
});

// Use Cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendMessageUseCase(repository);
});

final getMessagesUseCaseProvider = Provider<GetMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetMessagesUseCase(repository);
});

