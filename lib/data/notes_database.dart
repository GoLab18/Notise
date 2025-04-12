import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/note.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier {
  static late Isar isar;
  
  final List<Note> currentNotes = [];
  final List<Folder> currentFolders = [];
  
  List<Note> currNotesSearch = [];
  List<Folder> currFoldersSearch = [];

  String lastSearchQuery = "";
  int searchOffset = 0;
  bool isEverythingFound = false;
  
  static Future<void> initialization() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema, FolderSchema],
      directory: dir.path
    );
  }

  // Notes

  // C
  Future<void> addNote(String noteTitle, String noteText, int? folderId) async {
    final Note newNote = Note()..title = noteTitle..text = noteText..initDate = DateTime.now();

    if (folderId != null) {
      if (await isar.folders.filter().idEqualTo(folderId).isNotEmpty()) newNote.folderId = folderId;
    }

    await isar.writeTxn(() => isar.notes.put(newNote));

    if (folderId != null) await updateFolderNotesCount(folderId, 1);
    
    await fetchNotes();
  }

  // R
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().sortByIsPinnedDesc().thenByInitDateDesc().findAll();

    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);

    notifyListeners();
  }

  // U
  Future<void> updateNote(int id, String? newTitle, String? newText) async {
    final Note? existingNote = await isar.notes.get(id);

    if (existingNote == null) return;
    
    if (newTitle != null) existingNote.title = newTitle;
    if (newText != null) existingNote.text = newText;

    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
  }

  // D
  Future<void> deleteNote(Note note) async {
    await isar.writeTxn(() => isar.notes.delete(note.id));

    await fetchNotes();
    if (note.folderId != null) await updateFolderNotesCount(note.folderId!, -1);
  }

  Future<void> changeNotePinStatus(int id) async {
    final Note? existingNote = await isar.notes.get(id);

    if(existingNote == null) return;

    // Reverse the pin state
    existingNote.isPinned = !existingNote.isPinned;

    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
  }


  // Folders

  // C
  Future<void> addFolder(String name) async {
    final Folder newFolder = Folder()..name = name..initDate = DateTime.now();

    await isar.writeTxn(() => isar.folders.put(newFolder));

    await fetchFolders();
  }

  // R
  Future<void> fetchFolders() async {
    List<Folder> fetchedFolders = await isar.folders.where().sortByIsPinnedDesc().thenByInitDateDesc().findAll();

    currentFolders.clear();
    currentFolders.addAll(fetchedFolders);

    notifyListeners();
  }

  // U
  Future<void> updateFolder(int id, String newName) async {
    final Folder? existingFolder = await isar.folders.get(id);

    if (existingFolder == null) return;

    existingFolder.name = newName;

    await isar.writeTxn(() => isar.folders.put(existingFolder));

    await fetchFolders();
  }

  Future<void> updateFolderNotesCount(int folderId, int incrementValue) async {
    Folder folder = await isar.folders.get(folderId) as Folder;
    
    folder.notesCount += incrementValue;

    await isar.writeTxn(() => isar.folders.put(folder));

    await fetchFolders();
  }

  // D
  Future<void> deleteFolder(int folderId) async {
    List<Note> folderNotes = await isar.notes.filter().folderIdEqualTo(folderId).findAll();
    List<int> folderNotesIds = [];
    
    if (folderNotes.isNotEmpty) {
      for (Note note in folderNotes) {
        folderNotesIds.add(note.id);
      }
      
      await isar.writeTxn(() => isar.notes.deleteAll(folderNotesIds));

      await fetchNotes();
    }

    await isar.writeTxn(() => isar.folders.delete(folderId));

    await fetchFolders();
  }

  Future<void> changeFolderPinStatus(int id) async {
    final Folder? existingFolder = await isar.folders.get(id);

    if(existingFolder == null) return;

    // Reverse the pin state
    existingFolder.isPinned = !existingFolder.isPinned;

    await isar.writeTxn(() => isar.folders.put(existingFolder));

    await fetchFolders();
  }


  // Note operations with folders

  // C
  Future<void> addNoteToFolder(int noteId, int? folderId, String? newFolderName) async {
    if (folderId == null && newFolderName == null) throw Exception("Either folderId or newFolderName has to be specified");

    final Note? existingNote = await isar.notes.get(noteId);
    
    if (existingNote == null) throw Exception("Fetched note the from database is null");
    
    Folder? folder;
    
    // Add note to an existing folder if folderId specified
    if (folderId != null) folder = await isar.folders.get(folderId);
    
    if (folder != null) folder.notesCount++;

    // Add a new folder if folderId not specified
    folder ??= Folder()
      ..name = newFolderName!
      ..initDate = DateTime.now()
      ..notesCount = 1;
    


    existingNote.folderId = await isar.writeTxn(() async => await isar.folders.put(folder!));
    await isar.writeTxn(() async => await isar.notes.put(existingNote));

    await fetchNotes();
    await fetchFolders();
  }

  // D
  Future<void> deleteNoteFromFolder(int noteId) async {
    final Note? existingNote = await isar.notes.get(noteId);

    if (existingNote == null) throw Exception("Note not found, unable to delete from the folder");

    await updateFolderNotesCount(existingNote.folderId!, -1);

    existingNote.folderId = null;
    
    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
  }

  Stream<Folder?> fetchFolderStream(int folderId) {
    return isar.folders.watchObject(folderId);
  }

  /// Full-text searches notes by [query] with prefix searching.
  /// When [isInitial] equals false, method handles pagination starting from it's value.
  Future<void> searchNotes(String query, [bool isInitial = true, int limit = 18]) async {
    lastSearchQuery = query;
    if (isInitial) {
      isEverythingFound = false;
      searchOffset = 0;
    }

    if (isEverythingFound) return;

    if (query.isEmpty) {
      currNotesSearch = [];
      notifyListeners();
      return;
    }

    late List<Note> noteResults;

    if (!query.contains(" ")) {
      // Leveraging word-based prefix matching for better performance
      noteResults = await isar.notes
        .filter()
        .titleWordsElementStartsWith(query, caseSensitive: false)
        .or()
        .textWordsElementStartsWith(query, caseSensitive: false)
        .sortByIsPinnedDesc()
        .thenByInitDate()
        .offset(searchOffset)
        .limit(limit)
        .findAll();
    } else {
      // Linear contains search as a fallback
      noteResults = await isar.notes
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .textContains(query, caseSensitive: false)
        .sortByIsPinnedDesc()
        .thenByInitDate()
        .offset(searchOffset)
        .limit(limit)
        .findAll();
    }

    if (noteResults.length < limit) isEverythingFound = true;

    (isInitial) ? currNotesSearch = noteResults : currNotesSearch.addAll(noteResults);

    searchOffset += limit;

    notifyListeners();
  }

  /// Full-text searches folders by [query] with prefix searching.
  /// When [isInitial] equals false, method handles pagination starting from it's value.
  Future<void> searchFolders(String query, [bool isInitial = true, int limit = 18]) async {
    lastSearchQuery = query;
    if (isInitial) searchOffset = 0;

    if (query.isEmpty) {
      currFoldersSearch = [];
      notifyListeners();
      return;
    }

    late List<Folder> folderResults;

    if (!query.contains(" ")) {
      // Leveraging word-based prefix matching for better performance
      folderResults = await isar.folders
        .filter()
        .nameWordsElementStartsWith(query, caseSensitive: false)
        .sortByIsPinnedDesc()
        .thenByInitDate()
        .offset(searchOffset)
        .limit(limit)
        .findAll();
    } else {
      // Linear contains search as a fallback
      folderResults = await isar.folders
        .filter()
        .nameContains(query, caseSensitive: false)
        .sortByIsPinnedDesc()
        .thenByInitDate()
        .offset(searchOffset)
        .limit(limit)
        .findAll();
    }

    (isInitial) ? currFoldersSearch = folderResults : currFoldersSearch.addAll(folderResults);

    searchOffset += limit;

    notifyListeners();
  }

  Future<void> clearSearchResults(bool isNote) async {
    lastSearchQuery = "";
    (isNote) ? currNotesSearch.clear() : currFoldersSearch.clear();
    searchOffset = 0;
  }
}