import 'dart:io';

import 'models/task.dart';
import 'utils.dart' show binarySearch;

class Database {
  static const path = '/home/parfaitd/Work/Dart/todo/bin/src/db.csv';
  Database();
  File get stream {
    return File(path);
  }

  Future<List<Task>> get all async {
    var lines = await stream.readAsLines();

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

  Future<File> create() async {
    return stream.create();
  }

  void insert(Task task) async {
    var rows = await all;
    if (rows.isNotEmpty && task.id == 0) {
      task.id = rows.last.id + 1;
    }
    stream.writeAsString(task.toCsv(), mode: FileMode.append);
    stream.writeAsString(Platform.lineTerminator, mode: FileMode.append);
  }

  Future<Task?> get(int id) {
    var lines = stream.readAsLinesSync();
    var ids = lines.map(
      (line) => line.split(',')[0],
    ) as List<String>;

    var idx = binarySearch(id, ids);
    if (idx != null) {
      var line = lines[idx];
      var parts = line.split(',');
      return Future(
        () => Task(
          id: int.parse(parts[0]),
          title: parts[1],
          isDone: parts[2] == '1',
          description: parts[3],
          dueDate: parts[4].isNotEmpty ? DateTime.parse(parts[4]) : null,
        ),
      );
    }
    return Future(() => null);
  }
}
