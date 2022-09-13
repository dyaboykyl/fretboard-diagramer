import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent logEvent) {
    var color = PrettyPrinter.levelColors[logEvent.level]!;
    final errorColor = PrettyPrinter.levelColors[Level.error]!;
    final timestamp = DateTime.now().toLocal();
    final messages = [color('$timestamp $className - ${logEvent.message}')];
    if (logEvent.error != null) {
      messages.add(errorColor('${logEvent.error}'));
    }
    if (logEvent.stackTrace != null) {
      logEvent.stackTrace.toString().split('\n').take(8).forEach((line) {
        messages.add(errorColor(line));
      });
    }
    return messages;
  }
}

Logger logger(String className) => Logger(printer: SimpleLogPrinter(className));
