import 'package:gallerycubit/dataprovider/database/database_service.dart';
import 'package:gallerycubit/model/Image.dart';
import 'package:sqflite/sqflite.dart';

class ImageTable {
  // add record
  Future<void> saveImagesListToDB(List<Image> listImages) async {
    try {
      Database? _db = await DatabaseService.instance.database;
      Batch batch = _db!.batch();
      for (var image in listImages) {
        batch.insert(
          "image",
          image.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      Exception(e);
    }
  }

  Future<int> deleteCurrentSignedUser(String email) async {
    try {
      Database? _db = await DatabaseService.instance.database;
      int isDeleted =
          await _db!.delete("user", where: 'email = ?', whereArgs: [email]);
      return isDeleted;
    } catch (e) {
      throw Exception(e);
    }
  }

  // count the number of records
  Future<int?> fetchTotalUserRecordsLength() async {
    Database? db = await DatabaseService.instance.database;
    List? count = await db!.query('user');
    return count.length;
  }
}
