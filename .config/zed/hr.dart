import 'dart:convert';
import 'dart:io';

main(List<String> args) async {
  final process = await Process.start(
    "flutter",
    ["run"],
  );

  process.stderr.transform(utf8.decoder).forEach(stdout.write);
  process.stdout.transform(utf8.decoder).forEach(stdout.write);
  stdin.transform(utf8.decoder).forEach(process.stdin.write);

  final projectRoot = (args.firstOrNull ?? ".");

  print(projectRoot);

  final dir = Directory(projectRoot);

  dir.watch(recursive: true).listen((event) {
    print(event);
    if (event.path.endsWith(".dart")) {
      process.stdin.write("r");
    }
  });

  exit(await process.exitCode);
}
