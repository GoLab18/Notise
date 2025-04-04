import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notise/data/folder.dart';
import 'package:notise/data/note.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase extends ChangeNotifier {
  static late Isar isar;
  
  final List<Note> currentNotes = [];
  final List<Folder> currentFolders = [];
  
  Map<int, int> currentFoldersNotesAmounts = {};
  

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

    await fetchNotes();
    if (folderId != null) await fetchFolderNotesAmounts();
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
    if (note.folderId != null) await fetchFolderNotesAmounts();
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
    await fetchFolderNotesAmounts();
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
    await fetchFolderNotesAmounts();
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

    // Add a new folder if folderId not specified
    if (folder == null) {
      folder = Folder()..name = newFolderName!..initDate = DateTime.now();

      await isar.writeTxn(() => isar.folders.put(folder!));

      await fetchFolders();
    }

    existingNote.folderId = folder.id;
    
    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
    await fetchFolderNotesAmounts();
  }

  // R
  Future<void> fetchFolderNotesAmounts() async {
    List<Note> fetchedFoldersNotes = await isar.notes.filter()
      .folderIdIsNotNull().sortByFolderId().findAll();

    List<Folder> fetchedFolders = await isar.folders.where().
      sortByIsPinnedDesc().thenByInitDateDesc().findAll();

    Map<int, int> fetchedFoldersNotesAmounts = {};

    // Init the map of existing folders with default amounts = 0
    for (final Folder folder in fetchedFolders) {
      fetchedFoldersNotesAmounts[folder.id] = 0;
    }

    int? currentFolderId;
    int currentCount = 0;

    // Counting the notes inside all folders
    for (final Note note in fetchedFoldersNotes) {
      if (note.folderId != currentFolderId) {
        
        // Store if folderId changed
        if (currentFolderId != null) {
          fetchedFoldersNotesAmounts[currentFolderId] = currentCount;
        }

        fetchedFoldersNotesAmounts[note.folderId!] = 1;

        currentFolderId = note.folderId;
        currentCount = 1;
      } else {
        // Increment if folderId stays the same
        currentCount++;
      }
    }

    // Update the last folder's count
    if (currentFolderId != null) {
      fetchedFoldersNotesAmounts[currentFolderId] = currentCount;
    }

    currentFoldersNotesAmounts.clear();
    currentFoldersNotesAmounts.addAll(fetchedFoldersNotesAmounts);

    notifyListeners();
  }

  // D
  Future<void> deleteNoteFromFolder(int noteId) async {
    final Note? existingNote = await isar.notes.get(noteId);

    if (existingNote == null) throw Exception("Note not found, unable to delete from the folder");

    existingNote.folderId = null;
    
    await isar.writeTxn(() => isar.notes.put(existingNote));

    await fetchNotes();
    await fetchFolderNotesAmounts();
  }
}