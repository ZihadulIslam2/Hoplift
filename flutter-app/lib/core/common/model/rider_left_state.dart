class RiderLeftState {
  final String chatId;
  final String riderId;
  final String userId;

  RiderLeftState({required this.chatId, required this.riderId, required this.userId});

  factory RiderLeftState.fromJson(Map<String, dynamic> json) {
    return RiderLeftState(
      chatId: json['chatId'] as String,
      riderId: json['riderId'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'riderId': riderId,
      'userId': userId,
    };
  }
}