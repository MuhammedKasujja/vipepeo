class Question {
  final int id;
  final String question;
  final List topics;
  final String postedBy;
  final String postedOn;
  int totalAnswers;

  Question(
      {this.id,
      this.question,
      this.topics,
      this.postedBy,
      this.postedOn,
      this.totalAnswers});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'],
        question: json['quest'],
        topics: [],
        postedBy: json['posted_by'],
        postedOn: json['posted_on'],
        totalAnswers: json['answer_count']);
  }
}
