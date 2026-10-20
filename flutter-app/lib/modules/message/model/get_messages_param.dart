class GetMessagesParam {
  final String chatId;
  final int page;
  final int limit;

  GetMessagesParam({required this.chatId, required this.page, required this.limit});

  Map<String, dynamic> toMap() => {
        'chatId': chatId,
        'page': page,
        'limit': limit,
      };
}
