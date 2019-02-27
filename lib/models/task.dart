class Task{
  final int id;
  final String title;
  final String description;

  Task(this.id, this.title, this.description);

  factory Task.fromMap(Map<String, dynamic> json) => Task(
      json['id'],
      json['title'],
      json['description']
  );
}