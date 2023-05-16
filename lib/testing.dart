import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Question {
  final int id;
  final String question;
  final String answer;

  Question({this.id, this.question, this.answer});

  Map<String, dynamic> toMap() {
    return {'id': id, 'question': question, 'answer': answer};
  }
}

class CreateQuestionPage extends StatefulWidget {
  @override
  _CreateQuestionPageState createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  Future<Database> _database;

  @override
  void initState() {
    super.initState();
    _database = openDatabase(
        join(await getDatabasesPath(), 'questions.db'),
    onCreate: (db, version) {
    return db.execute(
    'CREATE TABLE questions(id INTEGER PRIMARY KEY, question TEXT, answer TEXT)',
    );
    },
    version: 1,
    );
  }

  Future<void> _insertQuestion(Question question) async {
    final db = await _database;

    await db.insert(
      'questions',
      question.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Question',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Answer',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter an answer';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final question = Question(
                      question: _questionController.text,
                      answer: _answerController.text,
                    );
                    _insertQuestion(question);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
