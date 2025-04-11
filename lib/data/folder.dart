import 'package:isar/isar.dart';

part 'folder.g.dart';

@collection
class Folder {
  Id id = Isar.autoIncrement;

  int notesCount = 0;

  late String name;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get nameWords => name.split(" ");

  bool isPinned = false;

  late DateTime initDate;
}