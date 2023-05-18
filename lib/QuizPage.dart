import 'package:flutter/material.dart';
import './QuizObject.dart';
import './database_helper.dart';

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import './profilePage.dart';
import './homeMenu.dart';
import './flashcardpage.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  CreateQuizPage()),
      );
    } else if (_currentIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => profile()),
      );
    }
  }

  late List<Quiz> quizzes = []; // Initialize with an empty list
  int currentQuizIndex = 0;
  int currentQuestionIndex = 0;
  TextEditingController answerController = TextEditingController();

  late Quiz currentQuiz;
  late QandA currentQuestion;
  late TextEditingController answerController;
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    currentQuiz = widget.quiz;
    currentQuestion = currentQuiz.qandAs[currentQuestionIndex];
    answerController = TextEditingController();
  }

  void loadQuizzes() async {
    quizzes = await DataBaseHelper().getAllQuizzes();
    setState(() {
      currentQuizIndex = 0;
      currentQuestionIndex = 0;
      answerController.clear();
    });
  }

  void goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < quizzes[currentQuizIndex].qandAs.length - 1) {
        currentQuestionIndex++;
        answerController.clear();
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Quiz Completed'),
              content: Text('You have completed the quiz.'),
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
        // You can choose to navigate to another page or perform any other action here
      }
    });
  }

  void checkAnswer() {
    String userAnswer = answerController.text.trim();
    String correctAnswer =
        quizzes[currentQuizIndex].qandAs[currentQuestionIndex].answer;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Answer Result'),
          content: Text(
            userAnswer == correctAnswer ? 'Correct!' : 'Incorrect!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                goToNextQuestion();
              },
              child: Text('Next Question'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (quizzes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Page'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Quiz currentQuiz = quizzes[currentQuizIndex];
    QandA currentQuestion = currentQuiz.qandAs[currentQuestionIndex];



    return Scaffold(


      backgroundColor: Colors.blue.shade100,


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quiz: ${currentQuiz.name}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Question ${currentQuestionIndex + 1}: ${currentQuestion.question}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                hintText: 'Enter your answer',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: checkAnswer,
              child: Text('Check Answer'),
            ),
          ],
        ),
      ),
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


    );
  }
}
