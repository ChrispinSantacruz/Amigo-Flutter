class Message {
  final String id;
  final String userId;
  final String text;
  final bool isFromUser;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.userId,
    required this.text,
    required this.isFromUser,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': text,
      'is_from_user': isFromUser,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    // Manejar diferentes formatos de fecha
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
      if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
      return DateTime.now();
    }

    return Message(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      text: json['message']?.toString() ?? json['text']?.toString() ?? '',
      isFromUser: json['is_from_user'] is bool 
          ? json['is_from_user'] 
          : (json['is_from_user'] ?? json['isFromUser'] ?? 0) == 1,
      createdAt: parseDate(json['created_at'] ?? json['createdAt']),
    );
  }
}

