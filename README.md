# Notise
#### Video Demo:  https://youtu.be/J0hdhOjD168
#### Description:

---

Notes app built with efficiency and ease in mind using Flutter, Provider, and Isar database.

---

## Features

### Note Management
- Create and edit notes with titles and content
- Pin important notes to the top
- Organize notes into folders

### Search
- Full-text search in notes and folders
- Word-based prefix matching for efficient searching
- Real-time search results highlighting
- Handles infinite scroll
- Case-insensitive

### Folder Organization
- Create and manage folders
- Add notes to folders
- View notes by folder
- Pin important folders

---

## Technical Stack

### Frontend
Built with Flutter and Provider for state management. Most utility options are handled via a bottom sheet overlay which are accessible through hold gestures with some being apart of the app bar.

### Database
- Isar database for local storage
- Optimized word-based indexing
- Prefix-based search with a fallback dynamic linear search for multi-word queries

---

## Setup
1. Ensure you have Flutter installed and set up
2. Clone the repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

---

## Future Enhancements

Planned features and improvements:
- **Cloud Sync**: Synchronize notes across devices
- **Tags**: Add and filter notes by tags
- **Export/Import**: Support for importing and exporting notes
- **Attachments**: Support for images and files in notes
- **Widgets**: Home screen widgets for quick note access

---
