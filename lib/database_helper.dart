import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import './QuizObject.dart';

class DataBaseHelper {
  static const _databaseName = "myDatabase2.db";
  static const _databaseVersion = 1;
  static const table = "My_Table";
  static const columnId = "_id";
  static const columnName = "_name";
  static const columnPassword = "_password";


  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnPassword TEXT NOT NULL
    )
    
    ''');
    await db.execute('''
      CREATE TABLE quiz(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      )
    ''');

    await db.execute('''
      CREATE TABLE qandas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      quiz_id INTEGER AUTOINCREMENT,
      question TEXT,
      answer TEXT,
      FOREIGN KEY (quiz_id) REFERENCES quiz (id)
     )
    
  ''');
  }


  Future<int> insert(Map<String, dynamic> row) async {
    return await _db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertQuiz(Quiz quiz) async {
    int quizId = await _db.insert('quiz', quiz.toMap());
    quiz.qandAs.forEach((qandA) async {
      await _db.insert('qandas', qandA.toMap(quizId));
    });
    return quizId;
  }
  Future<int> insertQandA(QandA qandA, Quiz quiz) async {
    int quizId = await _db.insert('quiz', quiz.toMap());
    qandA.quizId = quizId;
    return await _db.insert('qandas', qandA.toMap(quizId));
  }






  Future<List<Quiz>> getAllQuizzes() async {
    List<Map<String, dynamic>> quizMaps = await _db.query('quiz');
    List<Quiz> quizzes = [];
    for (var quizMap in quizMaps) {
      List<Map<String, dynamic>> qandAMaps = await _db.query('qandas',
          where: 'quiz_id = ?', whereArgs: [quizMap['id']]);
      List<QandA> qandAs = qandAMaps
          .map((qandAMap) => QandA.fromMap(qandAMap))
          .toList();
      Quiz quiz = Quiz.fromMap(quizMap, qandAs);
      quizzes.add(quiz);
    }
    return quizzes;
  }

}
