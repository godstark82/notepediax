import 'dart:developer';

import 'package:course_admin/constants/db.dart';
import 'package:course_admin/models/notes_model.dart';
import 'package:flutter/foundation.dart';

class NotesProvider extends ChangeNotifier {
  final List<NotesModel> _notes = (db.value['notes'] ?? [])
      .map((notes) => NotesModel.fromJson(notes))
      .toList();

  List<NotesModel> get notes => _notes;

  Future<bool> fetchNotes() async {
    try {
      _notes.clear();
      final coll = await admin.doc('db').collection('notes').get();
      final docs = coll.docs;
      for (int i = 0; i < docs.length; i++) {
        _notes.add(NotesModel.fromJson(docs[i].data()));
      }

      _notes.toSet().toList();
      _notes.sort((a, b) => a.time.compareTo(b.time));
      log('Noteses Fetched: ${notes.length}');
      notifyListeners();
    } catch (e) {
      //
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return true;
  }

  Future<void> saveNotesToFirestore(NotesModel note) async {
    _notes.add(note);
    await admin.doc('db').collection('notes').add(note.toJson());
    notifyListeners();
  }

    Future<void> deleteItem(int index, NotesModel notes) async {
    try {
      _notes.removeAt(index);
      final collection = await admin.doc('db').collection('notes').get();
      for (int i = 0; i < collection.docs.length; i++) {
        if (collection.docs[i].data()['title'] == notes.title) {
          await collection.docs[i].reference.delete();
        }
      }
      log('Notes deleted');
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }
}
