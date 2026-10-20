class NotificationModel {
  final String id;
  final String user;
  final String type;
  final String ride;
  final String message;
  final bool isRead;
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.user,
    required this.type,
    required this.ride,
    required this.message,
    required this.isRead,
    required this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String,
      user: json['user'] as String,
      type: json['type'] as String,
      ride: json['ride'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] == null ? false : (json['isRead'] as bool),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'type': type,
      'ride': ride,
      'message': message,
      'isRead': isRead,
      'expiresAt': expiresAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? user,
    String? type,
    String? ride,
    String? message,
    bool? isRead,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      user: user ?? this.user,
      type: type ?? this.type,
      ride: ride ?? this.ride,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
