import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Common/bloc/commonState.dart';
import 'package:todo_app/Features/TodoListing/event/Todo_event.dart';
import 'package:todo_app/Features/TodoListing/resources/todo_repositary.dart';

class CreateTodoListingCubit extends Bloc<todoEvent,CommonState> {
  final TodoRepositary repositary;
  CreateTodoListingCubit({required this.repositary}) : super(CommonInitialState()){
   on<CreateTodoEvent>((event, emit)async{
    await Future.delayed(Duration(seconds: 1));
    emit(CommonLoadingState());
    final res = await repositary.addTodo(event.title, event.description);
    res.fold(
      (error) =>emit(CommonErrorState(message: error)) ,
     (data) => emit(CommonSuccessState(itemData: data))
     );
     
     
   },
   transformer: droppable()
   );
   
   
  }

  // createTodo({required String title, required String description})async{
  //   emit(CommonLoadingState());
  //   final res = await repositary.addTodo(title, description);
  //   res.fold(
  //     (error) =>emit(CommonErrorState(message: error)) ,
  //    (data) => emit(CommonSuccessState(itemData: data))
  //    );
  // }
}