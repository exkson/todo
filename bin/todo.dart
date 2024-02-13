import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'src/db.dart';
import 'src/commands/create.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart todo.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> args) async {
  var db = Database();
  db.create().then(
        (value) => {
          CommandRunner('todo', 'A command-line todo app.')
            ..addCommand(CreateCommand(db: db))
            ..run(args)
        },
      );
}
