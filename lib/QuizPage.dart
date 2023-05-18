import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import './QuizObject.dart';
import './database_helper.dart';

class CreateQuizPage extends StatefulWidget {
  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  late List<QandA> questions;
  late TextEditingController quizNameController;
  late TextEditingController questionController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();
    questions = [];
    quizNameController = TextEditingController();
    questionController = TextEditingController();
    answerController = TextEditingController();
  }

  @override
  void dispose() {
    quizNameController.dispose();
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void addQuestion() {
    String questionText = questionController.text.trim();
    String answerText = answerController.text.trim();
    if (questionText.isNotEmpty && answerText.isNotEmpty) {
      QandA question = QandA(
        id: questions.length + 1,
        quizId: 0, // quizId can be set later when saving the quiz
        question: questionText,
        answer: answerText,
      );
      setState(() {
        questions.add(question);
        questionController.clear();
        answerController.clear();
      });
    }
  }

  void saveQuiz() async {
    String quizName = quizNameController.text.trim();
    if (quizName.isNotEmpty && questions.isNotEmpty) {
      Quiz quiz = Quiz(
        id: 0, // id can be set later when saving to database
        name: quizName,
        qandAs: questions,
      );
      // Insert the quiz and questions into the database
      int quizId = await DataBaseHelper().insertQuiz(quiz);
      quiz.id = quizId;
      quiz.qandAs.forEach((qandA) {
        qandA.quizId = quizId;
        DataBaseHelper().insertQandA(qandA, quiz);
      });

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Quiz Saved'),
            content: Text('Quiz has been saved successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the form
      setState(() {
        quizNameController.clear();
        questions.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quiz Name:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: quizNameController,
              decoration: InputDecoration(
                hintText: 'Enter quiz name',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Questions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  QandA question = questions[index];
                  return ListTile(
                    title: Text(
                      'Question ${index + 1}: ${question.question}',
                    ),
                    subtitle: Text('Answer: ${question.answer}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Add Question:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: questionController,
              decoration: InputDecoration(
                hintText: 'Enter question',
              ),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                hintText: 'Enter answer',
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: addQuestion,
              child: Text('Add'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveQuiz,
              child: Text('Save Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
