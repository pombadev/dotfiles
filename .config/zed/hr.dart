import 'dart:convert';
import 'dart:io';

main() async {
  final process = await Process.start(
    "flutter",
    ["run"],
  );

  process.stderr.transform(utf8.decoder).forEach(stdout.write);
  process.stdout.transform(utf8.decoder).forEach(stdout.write);
  stdin.transform(utf8.decoder).forEach(process.stdin.write);

  final dir = Directory("./lib");

  dir.watch(recursive: true).listen((event) {
    if (event.path.endsWith(".dart")) {
      process.stdin.write("r");
    }
  });

  exit(await process.exitCode);
}
