import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:todo_app/Common/Enum/todoEnum.dart';
import 'package:todo_app/common/bloc/commonState.dart';
import 'package:todo_app/common/services/sqlite_database_services.dart';
import 'package:todo_app/feature/add_todo/UI/pages/postTodo.dart';
import 'package:todo_app/feature/todo_listing/ui/custom_add_button.dart';
import 'package:todo_app/feature/todo_listing/ui/pages/todolist_card.dart';
import 'package:todo_app/feature/todo_listing/ui/pages/todolist_class.dart';
import 'package:dio/dio.dart';
import 'package:todo_app/feature/todo_listing/cubit/delete_todo_listing_cubit.dart';
import 'package:todo_app/feature/todo_listing/cubit/fetch_todo_listing_cubit.dart';

class MainTodoScreen extends StatefulWidget {
 const MainTodoScreen({super.key});

  @override
  State<MainTodoScreen> createState() => _MainTodoScreenState();
}

class _MainTodoScreenState extends State<MainTodoScreen> {
  bool isLoading = false;
  final databaseServices = DatabaseServices();
  final String noteID = "6498142a7be64eb9b5736389";
  final String delnoteID = "64478102d22b13104cada02";
  TodoStatus status = TodoStatus.All;

  // Future<List<todoList>> fetchData() async {
  //   final Map<String, dynamic> param = {};
  //   if (status != todoStatus.All) {
  //     param["completed"] = status == todoStatus.Completed ? true : false;
  //   }
  //   final response = await Dio().get(constant.notesURL, queryParameters: param);
  //   final result = List.from(response.data["data"])
  //       .map((e) => todoList.fromMap(e))
  //       .toList();
  //   return result;
  // }

  Future<Either<String, void>> onCompleted({required String noteID}) async {
    try {  
      final _ = await databaseServices.marksasTodos(tableID: noteID);
      return const Right(null);
    } on DioException catch (e) {
      return left(e.response?.data["message"] ?? "Unable to complete note");
    } catch (e) {
      return left("Unable to complete note");
    }
  }

  Future<Either<String, void>> onDeleted({required String tableID}) async {
    try {
      final _ = databaseServices.deleteTodos(tableID:tableID );
      return const Right(null);
    } on DioException catch (e) {
      return left(e.response?.data["message"] ?? "Unable to delete note");
    } catch (e) {
      return left("Unable to delete note");
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetchTododListingCubit>(context).fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
          appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                height: 70,
                child: const Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Icon(Icons.arrow_back),
                    SizedBox(
                      width: 80,
                    ),
                    Text(
                      "Sam's Project",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
            preferredSize: const Size.fromHeight(70),
          ),
          body: BlocListener<DeleteTodoListingCubit, CommonState>(
            listener: (context, state) {
             if(state is CommonLoadingState){
              setState(() {
                isLoading = true;
              });
             }else{
                setState(() {
                isLoading = true;
              });
             }

             if(state is CommonErrorState){
              Fluttertoast.showToast(msg: state.message);
             }else if(state is CommonSuccessState){
              Fluttertoast.showToast(msg: "Todo successfully deleted");
             }
            
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: TodoStatus.values
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  status = e;
                                });
                                context
                                    .read<FetchTododListingCubit>()
                                    .fetchTodo(status: e);
                              },
                              child: BlocSelector<FetchTododListingCubit,
                                  CommonState, String>(
                                selector: (state) {
                                  if (state is CommonSuccessState<
                                          List<todoList>> &&
                                      e == status) {
                                    return "(${state.itemData.length})";
                                  } else {
                                    return "";
                                  }
                                },
                                builder: (context, state) {
                                  return Chip(
                                    backgroundColor: e == status
                                        ? Colors.purple
                                        : Colors.grey.shade300,
                                    label: Text(
                                      e.name + state,
                                      style: TextStyle(
                                          color: e == status
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                 BlocBuilder<FetchTododListingCubit, CommonState>(
                      builder: (context, State) {
                    if (State is CommonErrorState) {
                      return Center(
                        child: Text(State.message),
                      );
                    } else if (State is CommonSuccessState) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: State.itemData.length,
                            itemBuilder: (context, index) {
                              return TodoListCard(
                                cardList: State.itemData[index],
                                onCompleted: (value) async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final res = await onCompleted(
                                      noteID: State.itemData[index].id);
                                  res.fold((msg) {
                                    Fluttertoast.showToast(msg: msg);
                                  }, (data) {
                                    Fluttertoast.showToast(
                                        msg: "Successfully completed");
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                onDeleted: (value) async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final response = await onDeleted(
                                      tableID: State.itemData[index].id);
                                  response.fold((msg) {
                                    Fluttertoast.showToast(msg: msg);
                                  }, (data) {
                                    Fluttertoast.showToast(
                                        msg: "Successfully deleted");
                                  });
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                              );
                            }),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  })
                ],
              ),
            ),
          ),
          floatingActionButton: Align(
              alignment: Alignment.bottomCenter,
              child: AddTaskButton(onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const PostTodoData()));
              }))),
    );
  }
}
