import 'package:flutter/material.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import './QuizObject.dart';
import './database_helper.dart';
import './profilePage.dart';
import './homeMenu.dart';

void main() {
  runApp(MaterialApp(
    home: CreateQuizPage(),
  ));
}

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({Key? key}) : super(key: key);

  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });

    if (_currentIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeMenu()),
      );
    } else if (_currentIndex == 1) {
      // Stay on the current page (CreateQuizPage)
    } else if (_currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => profile()),
      );
    }
  }

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QuizPage(quiz: quiz)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
        ),
        child: SizedBox(
          height: 100,
          child: FloatingNavbar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue.shade700,
            borderRadius: 40,
            onTap: (index) => _onItemTapped(index, context),
            currentIndex: _currentIndex,
            unselectedItemColor: Colors.grey,
            iconSize: 33,
            fontSize: 15,
            items: [
              FloatingNavbarItem(icon: Icons.home, title: 'Home'),
              FloatingNavbarItem(icon: Icons.menu_book, title: 'Quiz'),
              FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 70,),
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
            Flexible(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: addQuestion,
                    child: Text('Add'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: saveQuiz, // Add the onPressed callback
                    child: Text('Save Quiz'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}
