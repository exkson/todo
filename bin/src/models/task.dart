class Task {
  Task({
    this.id = 0,
    required this.title,
    this.isDone = false,
    this.description = "",
    this.dueDate,
  });

  int id = 0;
  String title;
  bool isDone;
  DateTime? dueDate;
  String description;

  String toCsv() {
    return '$id,$title,${isDone ? 1 : 0},$description,${dueDate?.toIso8601String() ?? ''}';
  }
}
