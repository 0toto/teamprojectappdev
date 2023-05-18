class Quiz {
  int id;
  String name;
  List<QandA> qandAs;

  Quiz({required this.id, required this.name, required this.qandAs});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map, List<QandA> qandAs) {
    return Quiz(
      id: map['id'],
      name: map['name'],
      qandAs: qandAs,
    );
  }
}

class QandA {
  int id;
  int quizId;
  String question;
  String answer;

  QandA({required this.id, required this.quizId, required this.question, required this.answer});

  Map<String, dynamic> toMap(int quizId) {
    return {
      'id': id,
      'quiz_id': quizId,
      'question': question,
      'answer': answer,
    };
  }

  factory QandA.fromMap(Map<String, dynamic> map) {
    return QandA(
      id: map['id'],
      quizId: map['quiz_id'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}



