import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();
  
  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await openDb();
    return _database!;
  }

  // Abrir db
  Future<Database> openDb() async{
    var databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'dbb.db');

    Database database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        // Tabela de alunos
        await db.execute(
          '''
            CREATE TABLE IF NOT EXISTS alunos(
              id INTEGER PRIMARY KEY,
              nome TEXT NOT NULL,
              idade INTEGER NOT NULL
            )
          )'''
        );
        // Tabela de Cursos
        await db.execute('''
          CREATE TABLE IF NOT EXISTS cursos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL
          )
        ''');

        // Tabela de Matrículas
        await db.execute('''
          CREATE TABLE IF NOT EXISTS matriculas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            aluno_id INTEGER NOT NULL,
            curso_id INTEGER NOT NULL,
            data_matricula TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE CASCADE,
            FOREIGN KEY (curso_id) REFERENCES cursos (id) ON DELETE CASCADE
          )
        ''');

        // Popular db
        await db.insert('cursos', {'nome': 'Ciência da Computação'});
        await db.insert('cursos', {'nome': 'Design Gráfico'});
        await db.insert('cursos', {'nome': 'Administração'});
      }
    );
    return database;

  }

  // CRUD
  // inserir aluno e retornar o seu id
  Future<int> insertAluno(Map<String, dynamic> alunoMap) async{
    final db = await database;
    return await db.insert('alunos', alunoMap);
  }

  // Lista todos os cursos
  Future<List<Map<String, dynamic>>> listarCursos() async {
    final db = await database;
    return await db.query('cursos');
  }

  // Inserir matricula (vincula aluno ao curso)
  Future<int> insertMatricula(int alunoId, int cursoId) async{
    
  }
}