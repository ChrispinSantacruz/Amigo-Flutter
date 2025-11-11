class User {
  final String id;
  final String email;
  final String name;
  final int age;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'age': age,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      age: (json['age'] is int) ? json['age'] : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      createdAt: parseDate(json['created_at']),
    );
  }
}

