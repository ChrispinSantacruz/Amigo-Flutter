import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDataSource {
  final SupabaseClient _supabase;

  SupabaseDataSource(this._supabase);

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final response = await _supabase.from('users').insert(userData).select().single();
    return response;
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await _supabase.from('users').update(userData).eq('id', userId);
  }
}




