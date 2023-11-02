import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:todo_app/Common/Enum/todoEnum.dart';
import 'package:todo_app/common/bloc/commonState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/feature/todo_listing/cubit/delete_todo_listing_cubit.dart';
import 'package:todo_app/feature/todo_listing/resources/todo_repositary.dart';
import 'package:todo_app/feature/add_todo/cubit/post_todo_cubit.dart';

class FetchTododListingCubit extends Cubit<CommonState> {
  final TodoRepositary repositary;
  final CreateTodoListingCubit createTodoListingCubit;
  final DeleteTodoListingCubit deleteTodoListingCubit;
  StreamSubscription ? subscription;
  TodoStatus ? lastparam;
  FetchTododListingCubit({required this.repositary,required this.createTodoListingCubit,required this.deleteTodoListingCubit}) : super(CommonInitialState()){
  
  subscription =Rx.merge( [ createTodoListingCubit.stream, deleteTodoListingCubit.stream ]).listen((event) {
    
    if(event is CommonSuccessState && lastparam!=null){
      // ignore: void_checks
      return fetchTodo(status: lastparam!);
    }
  });
  }

  fetchTodo({TodoStatus status = TodoStatus.All}) async{
    emit(CommonLoadingState());
    final res = await repositary.fetchTodos(status:status);
    lastparam = status;
    res.fold(
      (error){
        emit(CommonErrorState(message: error));
      }, 
      (data){
        emit(CommonSuccessState (itemData: data));
      }
      );
  }
  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}