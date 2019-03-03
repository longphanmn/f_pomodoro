class Task {
  final int id;
  final String title;
  final String description;
  bool done;
  int pomCount;

  Task(this.id, this.title, this.description, this.done, [this.pomCount = 0]);

  factory Task.fromMap(Map<String, dynamic> json) => Task(
      json['id'],
      json['title'],
      json['description'],
      json['done'] == 1 ? true : false,
      json['pomCount']);
}
