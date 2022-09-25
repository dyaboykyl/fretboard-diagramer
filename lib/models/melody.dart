import 'package:fretboard_diagramer/models/Key.dart';
import 'package:fretboard_diagramer/models/note.dart';
import 'package:fretboard_diagramer/models/time_signature.dart';

class MelodyComponent {
  final double duration;
  final Note note;

  MelodyComponent({required this.duration, required this.note});
}

class Melody {
  final TimeSignature timeSignature;
  final List<MelodyComponent> components;
  final Key? key;

  Melody({required this.components, required this.timeSignature, this.key});
}
