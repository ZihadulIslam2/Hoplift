class GetChatsParam {
  final int page;
  final int limit;

  GetChatsParam({required this.page, required this.limit});

  Map<String, dynamic> toMap() => {
        'page': page,
        'limit': limit,
      };
}
