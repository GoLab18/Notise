import 'package:isar/isar.dart';

part 'folder.g.dart';

@collection
class Folder {
  Id id = Isar.autoIncrement;

  late String name;
  List<int> notesIds = [];

  bool isPinned = false;

  late DateTime initDate;
}