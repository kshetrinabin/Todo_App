import 'package:flutter/material.dart';

class AddTaskButton extends StatefulWidget {
  final VoidCallback? onPressed;
  const AddTaskButton({super.key,this.onPressed});

  @override
  State<AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<AddTaskButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100,right: 60),
      child: InkWell(
         onTap: widget.onPressed,
        child: Container(
          height: 50,
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
         
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 113, 56, 203),
            borderRadius: BorderRadius.circular(16)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.add,color: Colors.white,),
              Text("New Task",style: TextStyle(
                color: Colors.white
              ),)
            ],
          ),
        ),
      ),
    );
  }
}