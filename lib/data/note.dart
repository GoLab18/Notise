import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;

  late String title;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get titleWords => title.split(" ");

  late String text;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get textWords => text.split(" ");

  bool isPinned = false;

  int? folderId;

  late DateTime initDate;
}
