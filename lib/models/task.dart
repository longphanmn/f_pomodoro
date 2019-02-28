class Task{
  final int id;
  final String title;
  final String description;
  final bool done;

  Task(this.id, this.title, this.description, this.done);

  factory Task.fromMap(Map<String, dynamic> json) => Task(
      json['id'],
      json['title'],
      json['description'],
      json['done']
  );
}