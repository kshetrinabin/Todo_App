// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jiffy/jiffy.dart';

import 'package:todo_app/Features/TodoListing/UI/Pages/Todolistclass.dart';
import 'package:todo_app/Features/TodoListing/cubit/delete_todo_listing_cubit.dart';

import '../../event/Todo_event.dart';

class TodoListCard extends StatelessWidget {

 final todoList cardList;
 final ValueChanged<BuildContext> onCompleted;
 final ValueChanged<BuildContext> ? onDeleted;
 
  const TodoListCard({
    Key? key,
    required this.cardList,
    required this.onCompleted,
     this.onDeleted
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(), 
        children:[
          if(cardList.isCompleted == false)
          SlidableAction(
            onPressed:onCompleted ,
            icon: Icons.check,
            label: "Complete",
            backgroundColor: Colors.green,
          ),
          
           SlidableAction(
            // onPressed: onDeleted,
            onPressed: (context) {
              context.read<DeleteTodoListingCubit>().add(DeleteTodoEvent(todoID:cardList.id ));
            },
            icon: Icons.delete,
            label: "Delete",
            backgroundColor: Colors.red,
          )
          
        ]
        ),
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
        margin: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(209, 221, 236, 241),
        borderRadius: BorderRadius.circular(18)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  cardList.title,
                  style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),),
                Text(cardList.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  
                ),),
                RichText(text: TextSpan(
                  text: "",
                  children: [
                    const WidgetSpan(
                      child:Icon(Icons.calendar_today,color: Colors.grey,size: 18,) ),
                      TextSpan(
                        text: Jiffy.parseFromDateTime(
                          cardList.createdAt.toLocal()
                        ).format(
                          pattern: " yyyy-MM-dd hh:mm:ss aa"
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        )
                      ),
                  ]
                ))
              ],
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
           
              children: [
                const SizedBox(height: 4,),
               Container(
                height: 8,
                width:8 ,
                decoration: BoxDecoration(
                  color: cardList.isCompleted ? Colors.green : Colors.red,
                  shape: BoxShape.circle
                ),
               ),
                
               
                  const SizedBox(height: 4,),
               const CircleAvatar(
                minRadius: 16,
                backgroundImage:AssetImage("assets/images/20211113_140325.jpg",),
                 
               )
              ],
            )
          ],
        ),
      ),
    );
  }
}
