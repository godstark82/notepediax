import 'dart:developer';
import 'package:course_app/constants/db.dart';
import 'package:course_app/models/notes_model.dart';
import 'package:course_app/provider/course_provider.dart';
import 'package:flutter/foundation.dart';

class NotesProvider extends ChangeNotifier {
  final List<NotesModel> _notes = db.value['notes'] != null
      ? (db.value['notes'] as List)
          .map((note) => NotesModel.fromJson(note))
          .toList()
      : [];

  List<NotesModel> get notes => _notes;

  Future<bool> fetchNotes() async {
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

    return true;
  }
}
