import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/data/folder.dart';
import 'package:notes_app/data/note.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier {
  static late Isar isar;
  
  final List<Note> currentNotes = [];
  final List<Folder> currentFolders = [];

  static Future<void> initialization() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema, FolderSchema],
      directory: dir.path
    );
  }


  // Notes

  // C
  Future<void> addNote(String noteTitle, String noteText) async {
    final Note newNote = Note()..title = noteTitle..text = noteText..initDate = DateTime.now();

    await isar.writeTxn(() => isar.notes.put(newNote));

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
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));

    await fetchNotes();
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

  // D
  Future<void> deleteFolder(int id) async {
    await isar.writeTxn(() => isar.folders.delete(id));

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


  // Adding notes to folders

  // C
  Future<void> addNoteToFolder(int noteId, int? folderId, String? newFolderName) async {
    if (folderId == null && newFolderName == null) throw Exception("Either folderId or newFolderName has to be specified");

    final Note? existingNote = await isar.notes.get(noteId);
    
    if (existingNote == null) throw Exception("Fetched note the from database is null");
    
    Folder? folder;
    
    // Add note to an existing folder if folderId specified
    if (folderId != null) {
     folder = await isar.folders.get(folderId);

      // Ensuring the notesIds list is growable
      folder!.notesIds = List<int>.from(folder.notesIds);
      
      folder.notesIds.add(noteId);
    }

    // Add a new folder if folderId not specified
    folder ??= Folder()..name = newFolderName!..initDate = DateTime.now()..notesIds = [noteId];
    
    await isar.writeTxn(() => isar.folders.put(folder!));

    await fetchFolders();
  }

  // D
  Future<void> deleteNoteFromFolder(int noteId, int folderId) async {
    final Note? existingNote = await isar.notes.get(noteId);
    final Folder? existingFolder = await isar.folders.get(folderId);

    if (existingNote == null || existingFolder == null) return;

    existingFolder.notesIds.remove(noteId);
    
    await isar.writeTxn(() => isar.folders.put(existingFolder));

    await fetchFolders();
  }
}