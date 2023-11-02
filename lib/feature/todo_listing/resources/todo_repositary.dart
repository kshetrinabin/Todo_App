import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/Common/services/Sqlite_database_services.dart';
import 'package:todo_app/Features/TodoListing/UI/Pages/Todolistclass.dart';

class TodoRepositary{

  List<todoList> _todos = [];

  List<todoList> get todos => _todos;

  final databaseServices = DatabaseServices();

  final String delnoteID = "64478102d22b13104cada02";
  
  Future<Either<String,List<todoList>>> fetchTodos({required status}) async{

    try{
    
    // final Map<String,dynamic> param = {};
    final result = await databaseServices.getTodos(status: status);
    // final response =await Dio().get(constant.notesURL,queryParameters: param);
    // final result = List.from(response.data["data"]).map((e) => todoList.fromMap(e)).toList();
    
     _todos.clear();
     _todos.addAll(result);
     return Right(_todos);

    }on DioException catch(e){
     
     return Left(e.response?.data["message"] ?? "Unable to fetch todd");

    }catch(e){
      return left(e.toString());

    }
  }
  Future<Either<String,todoList>> addTodo(String title,String description)async{
   try{
  //    final res = await Dio().post(
  //     constant.notesURL,
  //     data:
  //     {
  //       "title": title,
  //       "description":description
  //     } 
  //     );
  //  return Right(todoList.fromMap(res.data["data"]));
     final res = await databaseServices.addTodd(title: title, desciption: description);
     return Right(res);
   }on DioException catch(e){
   
    return Left(e.response?.data["message"] ?? "Unable to add Todo");
   }catch(e){
     return left(e.toString());
   }
  }


   Future<Either<String, void>> onDeleted({required String delnoteID}) async {
    try {
      // final _ = Dio().delete("${constant.notesURL}/$delnoteID/");
      final _ = await databaseServices.deleteTodos(tableID: delnoteID);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.response?.data["message"] ?? "Unable to delete note");
    } catch (e) {
      return Left(e.toString());
    }
  }
}