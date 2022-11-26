import 'package:logger/logger.dart';

final levelColors = {
  Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
  Level.debug: AnsiColor.fg(228),
  Level.info: AnsiColor.fg(12),
  Level.warning: AnsiColor.fg(208),
  Level.error: AnsiColor.fg(196),
  Level.wtf: AnsiColor.fg(199),
};
final textColor = AnsiColor.fg(15);

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    var color = levelColors[event.level]!;
    final errorColor = PrettyPrinter.levelColors[Level.error]!;
    final timestamp = DateTime.now().toLocal();
    final messages = ['${color('$timestamp $className')} - ${textColor(event.message)}'];
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
