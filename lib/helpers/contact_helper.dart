import 'package:agenda_contatos/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactHelper {
  static final ContactHelper instance = ContactHelper._init();

  static Database? _database;

  ContactHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('agenda.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableContact (
  ${ContactFields.columnId} INTEGER PRIMARY KEY,
  ${ContactFields.columnName} TEXT,
  ${ContactFields.columnImg} TEXT,
  ${ContactFields.columnEmail} TEXT,
  ${ContactFields.columnPhone} INTEGER
)
''');
  }

  Future<Contact> saveContact(Contact contact) async {
    final db = await instance.database;
    contact.id = await db.insert(tableContact, contact.toJson());
    return contact;
  }

  Future<Contact> readContact(int id) async {
    final db = await instance.database;
    final List<Map<String, Object?>> maps = await db.query(tableContact,
        columns: ContactFields.values,
        where: "${ContactFields.columnId} = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Contact.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete(tableContact,
        where: "${ContactFields.columnId} = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return db.update(tableContact, contact.toJson(),
        where: "${ContactFields.columnId} = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> readAllContacts() async {
    final db = await instance.database;
    List listMap = await db.rawQuery("SELECT * FROM $tableContact");
    List<Contact> listContact = [];
    for (Map<String, Object?> m in listMap) {
      listContact.add(Contact.fromJson(m));
    }
    return listContact;
  }

  getNumber() async {
    final db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tableContact"));
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
