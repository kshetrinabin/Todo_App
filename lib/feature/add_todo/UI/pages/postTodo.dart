import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:todo_app/Common/bloc/commonState.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/Features/TodoListing/event/Todo_event.dart';
import 'package:todo_app/Features/postTodo/cubit/post_todo_cubit.dart';


class PostTodoData extends StatefulWidget {

const PostTodoData({super.key});

  @override
  State<PostTodoData> createState() => _PostTodoDataState();
}

class _PostTodoDataState extends State<PostTodoData> {

  bool  loading = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  
  // Future<void> savedTodo() async{
   
  //  try{
  //   setState(() {
  //     loading= true;
  //   });
  //   final _ = await Dio().post(
  //     constant.notesURL,
  //     data: {
  //       "title":titleController.text,
  //       "description":descriptionController.text,
        
  //     }
  //     );
  //     Fluttertoast.showToast(msg: "Todo saved successfully");
  //     Navigator.of(context).pop(true);
  //  }
  //  catch(e){
  //   Fluttertoast.showToast(msg: e.toString());
  //  }
  //  finally{
  //   setState(() {
  //     loading = false;
  //   });
  //  }
  // }
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Todo "),
          elevation: 0,
          centerTitle: true,
        ),
      body:  BlocListener<CreateTodoListingCubit, CommonState>(
          listener: (context, state) {
          if(state is CommonLoadingState){
          setState(() {
           loading = true;
          });
          }else{
            setState(() {
              loading =  false;
            });
          }

          if(state is CommonErrorState){
            Fluttertoast.showToast(msg: state.message);
          }else{
            Fluttertoast.showToast(msg: "Todo created successfully");
          }
          },
          child:SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: "Enter Title",
                              label: Text("Title")
                            ),
                          ),
                          SizedBox(height: 16,),
                           TextFormField(
                            controller: descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Enter Description",
                              label: Text("Description"),
                              
                            ),
                          ),
                          SizedBox(height: 30,),
                          TextButton(
                            onPressed: (){
                              // savedTodo();
                              context.read<CreateTodoListingCubit>().add(CreateTodoEvent(title: titleController.text, description: descriptionController.text));
                            }, 
                            child: Text(
                              "saved",style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                            )
                        ],
                
                        
                      ),
                    ),
                  ),
        ),
        ),
    );
    
  }
}