import 'dart:io';

import 'models/task.dart';
import 'utils.dart' show binarySearch;

class Database {
  static final path = [
    Platform.environment['HOME'] ?? '.',
    '.todo-db.csv',
  ].join('/');

  Database();
  File get stream {
    return File(path);
  }

  List<Task> get all {
    var lines = stream.readAsLinesSync();

    return lines.map(
      (line) {
        var parts = line.split(',');
        return Task(
          id: int.parse(parts[0]),
          title: parts[1],
          isDone: parts[2] == '1',
          description: parts[3],
          dueDate: parts[4].isNotEmpty ? DateTime.parse(parts[4]) : null,
        );
      },
    ).toList();
  }

  Database create() {
    if (!stream.existsSync()) {
      stream.createSync();
    }
    return this;
  }

  void insert(Task task) {
    if (all.isNotEmpty && task.id == 0) {
      task.id = all.last.id + 1;
    }
    stream.writeAsStringSync(task.toCsv(), mode: FileMode.append);
    stream.writeAsStringSync(Platform.lineTerminator, mode: FileMode.append);
  }

  Task? get(int id) {
    var lines = stream.readAsLinesSync();
    var ids = lines.map(
      (line) => line.split(',')[0],
    ) as List<String>;

    var idx = binarySearch(id, ids);
    if (idx != null) {
      var line = lines[idx];
      var parts = line.split(',');
      return Task(
        id: int.parse(parts[0]),
        title: parts[1],
        isDone: parts[2] == '1',
        description: parts[3],
        dueDate: parts[4].isNotEmpty ? DateTime.parse(parts[4]) : null,
      );
    }
    return null;
  }
}
