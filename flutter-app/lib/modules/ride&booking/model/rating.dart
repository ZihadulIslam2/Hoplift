class Rating {
  final String userId;
  final double score;

  Rating({required this.userId, required this.score});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['userId'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'score': score,
    };
  }
}