// ignore_for_file: public_member_api_docs, sort_constructors_first

class QuizModel {
  String title;
  String description;
  String? image;
  double price;
  DateTime time;
  List<QuizQuestion> questions;
  bool isPurchased;
  bool? isAttempted;
  int? lastScore;
  List<int?>? lastResponse;
  QuizModel(
      {required this.title,
      required this.description,
      required this.image,
      required this.price,
      required this.time,
      required this.isPurchased,
      required this.questions,
      this.isAttempted,
      this.lastResponse,
      this.lastScore});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isPurchased': isPurchased,
      'description': description,
      'image': image,
      'price': price,
      'title': title,
      'time': time.toIso8601String(),
      'questions': questions.map((x) => x.toJson()).toList(),
      'isAttempted': isAttempted,
      'lastReponse': lastResponse,
      'lastScore': lastScore
    };
  }

  factory QuizModel.fromJson(Map<String, dynamic> map) {
    return QuizModel(
        description: map['description'],
        image: map['image'],
        price: double.parse(map['price'].toString()),
        isAttempted: map['isAttempted'],
        lastResponse: map['lastResponse'],
        lastScore: int.tryParse(map['lastScore'].toString()) ?? 0,
        isPurchased: false,
        title: map['title'].toString(),
        time: DateTime.parse(map['time']),
        questions: (map['questions'] as List)
            .map((question) => QuizQuestion.fromJson(question))
            .toList());
  }
  // Create a new QuizModel instance with updated properties
  QuizModel copyWith({
    String? title,
    String? description,
    String? image,
    double? price,
    DateTime? time,
    List<QuizQuestion>? questions,
    bool? isPurchased,
    bool? isAttempted,
    int? lastScore,
    List<int?>? lastResponse,
  }) {
    return QuizModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      time: time ?? this.time,
      questions: questions ?? this.questions,
      isPurchased: isPurchased ?? this.isPurchased,
      isAttempted: isAttempted ?? this.isAttempted,
      lastScore: lastScore ?? this.lastScore,
      lastResponse: lastResponse ?? this.lastResponse,
    );
  }

  @override
  String toString() =>
      'QuizModel(quizName: $title, time: $time, questions: $questions)';
}

class QuizQuestion {
  String question;
  String image;
  List<String> options;
  int correctAnswer;
  QuizQuestion({
    required this.question,
    required this.options,
    required this.image,
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'image': image,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> map) {
    return QuizQuestion(
      image: map['image'] ?? '',
      correctAnswer: int.parse(map['correctAnswer'].toString()),
      question: map['question'].toString(),
      options: (map['options'] as List).map((e) => '$e').toList(),
    );
  }

  @override
  String toString() =>
      'QuizQuestion(question: $question, options: $options, correctAnswer: $correctAnswer)';
}
