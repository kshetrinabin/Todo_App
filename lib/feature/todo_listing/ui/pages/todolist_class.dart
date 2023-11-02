
class todoList {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  bool isCompleted;
  todoList({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isCompleted,
  });

  factory todoList.fromMap(Map<String,dynamic> map){

    return todoList(
      id: map["_id"], 
     title: map["title"], 
      description: map["description"], 
      createdAt: DateTime.parse(map["createdAt"]), 
      isCompleted: map["completed"]
      );
  }

 factory todoList.fromDB(Map<String,dynamic> map){

    return todoList(
      id: map["_id"], 
     title: map["title"], 
      description: map["description"], 
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["Date"]).toLocal(), 
      isCompleted: map["completed"] == 1 ? true : false,
   );
  }

 
}
