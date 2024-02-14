import 'dart:io';

import 'package:args/command_runner.dart';

import 'src/db.dart';
import 'src/commands/create.dart';

const String version = '0.0.1';

void main(List<String> args) {
  var db = Database().create();
  var runner = CommandRunner('todo', 'A command-line todo app.')
    ..addCommand(CreateCommand(db: db));

  runner.run(args).catchError((e) {
    print(runner.usage);
    exit(62);
  });
}
