import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level]!;
    final errorColor = PrettyPrinter.levelColors[Level.error]!;
    final timestamp = DateTime.now().toLocal();
    final messages = [color('$timestamp $className - ${event.message}')];
    if (event.error != null) {
      messages.add(errorColor('${event.error}'));
    }
    if (event.stackTrace != null) {
      event.stackTrace.toString().split('\n').take(8).forEach((line) {
        messages.add(errorColor(line));
      });
    }
    return messages;
  }
}

Logger logger(String className) => Logger(printer: SimpleLogPrinter(className));
