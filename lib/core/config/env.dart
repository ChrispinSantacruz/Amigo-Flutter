class Env {
  // Supabase
  // URL de tu proyecto Supabase
  static const String supabaseUrl = 'https://lzvgxpwbmzdnvzlmebhv.supabase.co';
  
  // Publishable Key (anteriormente anon key)
  // Esta es la clave pública segura para usar en aplicaciones cliente
  // IMPORTANTE: Nunca uses la secret key en el código cliente
  static const String supabaseAnonKey = 'sb_publishable_5G1hgPkVDw7Unvm6-9OKgA_6y_DELDx';

  // Groq API
  static const String groqApiKey = 'YOUR_GROQ_API_KEY';
  static const String groqModel = 'llama-3.3-70b-versatile';
  static const String groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
}

