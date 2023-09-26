class ReviewDto {
  final int id;
  final int transactionId;
  final int writer;
  final int target;
  final int score;
  final String comment;

  ReviewDto({
      required this.id,
      required this.transactionId,
      required this.writer,
      required this.target,
      required this.score,
      required this.comment,
  });

  factory ReviewDto.fromJson(Map<String ,dynamic> json) {
    return ReviewDto(
        id: json['id'],
        transactionId: json['transactionId'],
        writer: json['writer'],
        target: json['target'],
        score: json['score'],
        comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'writer': writer,
      'target': target,
      'score': score,
      'comment': comment,
    };
  }
}
