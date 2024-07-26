import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;

  late String title;
  late String text;

  bool isPinned = false;

  late DateTime initDate;
}
