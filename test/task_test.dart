import 'package:test/test.dart';
import 'package:fpomodoro/models/task.dart';

void main() {
  test('Create task', () {
    final task = Task(1, "ABC", "abc", false);

    expect(task.title, "ABC");
    expect(task.description, "abc");
    expect(task.done, false);

    task.done = true;

    expect(task.done, true);
  });
}