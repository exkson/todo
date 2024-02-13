import 'package:args/command_runner.dart';

import '../models/task.dart';
import '../db.dart';

class CreateCommand extends Command {
  @override
  final name = 'create';
  @override
  final description = 'Create a new task.';

  Database db;

  CreateCommand({required this.db}) {
    argParser
      ..addOption(
        'title',
        abbr: 't',
        help: 'The title of the task.',
        valueHelp: 'title',
        mandatory: true,
      )
      ..addOption(
        'description',
        abbr: 'd',
        help: 'The description of the task.',
        valueHelp: 'description',
      )
      ..addOption(
        'due-date',
        abbr: 'D',
        help: 'The due date of the task.',
        valueHelp: 'due-date',
      )
      ..addFlag(
        'done',
        help: 'The task is done',
        negatable: false,
        defaultsTo: false,
      );
  }

  @override
  void run() {
    String title = argResults!['title'];
    String? description = argResults!['description'];
    bool isDone = argResults!['done'];

    var task = Task(
      title: title,
      description: description ?? '',
      isDone: isDone,
    );
    db.insert(task);
  }
}
