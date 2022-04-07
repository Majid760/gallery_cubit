class DataBaseTable {
  static String imageTable = '''
      CREATE TABLE IF NOT EXISTS image(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fileName TEXT NOT NULL,
        filePath TEXT NOT NULL,
        isPrimaryPhoto INTEGER  NOT NULL,
        updatedDate INTEGER NOT NULL,
        createdDate INTEGER NOT NULL
      )
      ''';
}
