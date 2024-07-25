import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/data/note.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier {
  static late Isar isar;
  
  final List<Note> currentNotes = [];

  static Future<void> initialization() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path
    );
  }

  // C
  Future<void> addNote(String noteTitle, String noteText) async {
    final newNote = Note()..title = noteTitle..text = noteText;

    await isar.writeTxn(() => isar.notes.put(newNote));

    await fetchNotes();
  }

  // R
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();

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

  Future<void> addToFolder(int id, String folder) async {
    final Note? existingNote = await isar.notes.get(id);

    if (existingNote == null) return;

    existingNote.folderName = folder;
    
    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
  }

  Future<void> pinNote(int id) async {
    final Note? existingNote = await isar.notes.get(id);

    if(existingNote == null) return;

    // Reverse the pin state
    existingNote.pinned = !existingNote.pinned;

    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
  }
}