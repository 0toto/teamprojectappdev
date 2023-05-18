import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import './quizpage.dart';
import './database_helper.dart';
import './model.dart';
import './homeMenu.dart';
import './profilePage.dart';
import './settingPage.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';




class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;

  final dbHelper = DataBaseHelper();
  final TextEditingController _quizNameController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  List<QandA> _qandaList = [];

  @override
  void initState() {
    super.initState();
    dbHelper.init(); // Initialize the database helper
  }

  @override
  void dispose() {
    dbHelper.close(); // Close the database connection
    _quizNameController.dispose();
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _insertQuiz() async {
    final quizName = _quizNameController.text.trim();
    if (quizName.isNotEmpty) {
      final insertedId = await dbHelper.insertQuiz(
          quizName,
          DataBaseHelper.getCurrentUser()[DataBaseHelper.columnName]
      );
      print('Inserted Quiz ID: $insertedId');
    } else {
      print('Quiz name cannot be empty');
    }
  }

  void _insertQandA() {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();

    if (question.isNotEmpty && answer.isNotEmpty) {
      final quizId = 1; // Assuming the quiz ID exists or obtained from user input

      final qanda = QandA(
        id: 0, // The ID will be auto-generated by the database
        quizId: quizId,
        question: question,
        answer: answer,
      );

      setState(() {
        _qandaList.add(qanda);
      });

      _questionController.clear();
      _answerController.clear();
    } else {
      print('Question and answer cannot be empty');
    }
  }

  void _saveQuiz() async {
    final quizName = _quizNameController.text.trim();
    if (quizName.isEmpty) {
      print('Quiz name cannot be empty');
      return;
    }

    final insertedId = await dbHelper.insertQuiz(
        quizName,
        DataBaseHelper.getCurrentUser()[DataBaseHelper.columnName]
    );
    print('Inserted Quiz ID: $insertedId');

    for (final qanda in _qandaList) {
      await dbHelper.insertQandA(insertedId, qanda.question, qanda.answer);
    }

    _quizNameController.clear();
    _questionController.clear();
    _answerController.clear();

    setState(() {
      _qandaList = [];
    });

    print('Quiz and QandA data saved to the database');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      extendBody: false,
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
            onTap: (int val) {
              setState(() {
                _currentIndex = val;
              });
              if (_currentIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeMenu()),
                );
              }
              if (_currentIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profile()),
                );
              }
              if (_currentIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => setting()),
                );
              }
            },
            currentIndex: _currentIndex,
            unselectedItemColor: Colors.grey,
            iconSize: 33,
            fontSize: 15,
            items: [
              FloatingNavbarItem(icon: Icons.home, title: 'Home'),
              FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
              FloatingNavbarItem(icon: Icons.settings, title: 'Setting'),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade100,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _quizNameController,
              decoration: InputDecoration(
                labelText: 'Quiz Name',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Questions and Answers:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  thickness: 1.0,
                ),
                itemCount: _qandaList.length,
                itemBuilder: (context, index) {
                  final qanda = _qandaList[index];
                  return ListTile(
                    title: Text(
                      'Q: ${qanda.question}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'A: ${qanda.answer}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Answer',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _insertQandA,
                    child: Text('Add Q&A'),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveQuiz,
                    child: Text('Save Quiz'),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
