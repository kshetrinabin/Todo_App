
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Common/Enum/todoEnum.dart';
import 'package:todo_app/feature/todo_listing/ui/pages/todolist_class.dart';
import 'package:uuid/uuid.dart';

class DatabaseServices{
  final String _dbname ="Todo_database";
  final int _dbversion = 1;

  final String _tablename ="todo";
  final String _tableID = "_id";
  final String _title ="title";
  final String _desciption ="description";
  final String _createdAt = "Date";
  final String _tableCompleted ="completed";

  Database ?_instance;

  Future<Database> get _database async{

    final dbpath = await getDatabasesPath();
    _instance??= await openDatabase("$dbpath/$_dbname",version: _dbversion,
    onCreate: (db, version) async{
      await db.execute(
         'CREATE TABLE $_tablename ($_tableID TEXT PRIMARY KEY, $_title TEXT, $_desciption TEXT, $_tableCompleted INTEGER DEFAULT 0 NOT NULL, $_createdAt INTEGER)'
         );
      
    },
    );
  return _instance!;
  }

  Future<todoList> addTodd({required String title,required String desciption})async{
    final database = await _database;
    final Map<String,dynamic> data = {
       _tableID:const Uuid().v4(),
      _title:title,
      _desciption:desciption,
      _createdAt:DateTime.now().microsecondsSinceEpoch,
    };

    final _ = await database.insert(_tablename, data);
    return todoList(
      id: data[_tableID], 
      title: title, 
      description: desciption, 
      createdAt: DateTime.fromMicrosecondsSinceEpoch(data[_createdAt]), 
      isCompleted:false,
  );

  }
  Future <List<todoList>> getTodos({TodoStatus status = TodoStatus.All})async{
  final database = await _database;
  final res = await database.query(
    _tablename,
    where: status != TodoStatus.All ? "$_tableCompleted = ?" : null,
    whereArgs: status != TodoStatus.All ? [status == TodoStatus.Completed ? 1 : 0] : null,
    );
  return res.map((e) => todoList.fromDB(e)).toList();
  }

  Future<void> marksasTodos({required String tableID}) async{

    final database = await _database;
    final _ = await database.update(
      _tablename, 
      {
       _tableCompleted : 1,
      },
      where: "$_tableID = ?",
      whereArgs: [tableID],
      );
  }
  Future<void> deleteTodos({required String tableID}) async{

    final database = await _database;
    final _ = await database.delete(
      _tablename, 
      where: "$_tableID = ?",
      whereArgs: [tableID],
      );
  }
}