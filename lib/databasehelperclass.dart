import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

class NotesDatabaseHelper {
  static const String _databaseName = 'notes_database.db';
  static const int _databaseVersion = 2; // Updated version
  static const String tableNotes = 'notes';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnPdfPath = 'pdfPath';
  static const String columnBranch = 'branches';
  static const String columnYear = 'year';
  static const String columnScheme = 'scheme';
  static const String columnSemester = 'semester';

  // Make this a singleton class
  NotesDatabaseHelper._privateConstructor();
  static final NotesDatabaseHelper instance =
  NotesDatabaseHelper._privateConstructor();

  late Database _database;

  Future<void> init() async {
    _database = await _initDatabase();
  }

  Future<Database> get database async {
    if (null != _database) {
      return _database;
    }

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Check if the column exists before trying to add it
      List<Map<String, dynamic>> columns =
      await db.rawQuery("PRAGMA table_info($tableNotes);");
      bool columnExists = columns.any((column) => column['name'] == columnPdfPath);

      if (!columnExists) {
        // If upgrading from version 1 to version 2, add the pdfPath column
        await db.execute('ALTER TABLE $tableNotes ADD COLUMN $columnPdfPath TEXT');
      }

      // Check if the "branches" column exists before trying to add it
      columnExists = columns.any((column) => column['name'] == columnBranch);

      if (!columnExists) {
        // If upgrading from version 1 to version 2, add the branches column
        await db.execute('ALTER TABLE $tableNotes ADD COLUMN $columnBranch TEXT');
      }

      // Add the missing columns
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN $columnYear TEXT');
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN $columnScheme TEXT');
      await db.execute('ALTER TABLE $tableNotes ADD COLUMN $columnSemester TEXT');
    }
    // Add more upgrade steps if needed for future versions
  }



  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotes (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT,
        $columnPdfPath TEXT,
        $columnBranch TEXT,
        $columnYear TEXT,
        $columnScheme TEXT,
        $columnSemester TEXT
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final Database db = await database;
    return db.insert(tableNotes, note.toMap());
  }

  Future<List<Note>> getFilteredNotes(
      String branch, String year, String scheme, String semester) async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableNotes,
        where: '$columnBranch = ? AND $columnYear = ? AND $columnScheme = ? AND $columnSemester = ?',
        whereArgs: [branch, year, scheme, semester]);

    return List.generate(maps.length, (index) {
      return Note(
        id: maps[index][columnId],
        title: maps[index][columnTitle],
        pdfPath: maps[index][columnPdfPath],
        branches: maps[index][columnBranch],
        year: maps[index][columnYear],
        scheme: maps[index][columnScheme],
        semester: maps[index][columnSemester],
      );
    });
  }


}
