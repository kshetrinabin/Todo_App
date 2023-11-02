import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Common/bloc/commonState.dart';
import 'package:todo_app/Features/TodoListing/event/Todo_event.dart';
import 'package:todo_app/Features/TodoListing/resources/todo_repositary.dart';

class DeleteTodoListingCubit extends Bloc<todoEvent,CommonState> {
  final TodoRepositary repositary;
  DeleteTodoListingCubit({required this.repositary}) : super(CommonInitialState()){
   on<DeleteTodoEvent>((event, emit)async{
    emit(CommonLoadingState());
    final res = await repositary.onDeleted(delnoteID: event.todoID);
    res.fold(
      (error) => emit(CommonErrorState(message: error)),
       (data) => emit(CommonSuccessState(itemData: null)),
       );
   });
  }
}
  // deleteTodo({required String delNoteID})async{
    // emit(CommonLoadingState());
    // final res = await repositary.onDeleted(delnoteID: delNoteID);
    // res.fold(
    //   (error) => emit(CommonErrorState(message: error)),
    //    (data) => emit(CommonSuccessState(itemData: data)),
    //    );
  // }
