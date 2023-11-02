abstract class todoEvent{}

class DeleteTodoEvent extends todoEvent{
  final String todoID;
  DeleteTodoEvent({required this.todoID});

}
class CreateTodoEvent extends todoEvent{
  final String title;
  final String description;
  CreateTodoEvent({required this.title,required this.description});
}