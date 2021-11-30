import 'package:flutter/cupertino.dart';
import 'package:notes_app/data/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/*
* extends stateless widget as there are no manipulations here.
* */
class NoteCard extends StatelessWidget{

  late Note note;

  //use deleteNote function to delete a note from the class that contains the dataset of notes
  final Function() deleteNote;

  late String noteSubject = note.subject.toString();
  late String noteNotes = note.notes.toString();

  final double defaultSubjectSize = 20.0;
  final double defaultNoteSize = 16.0;

  //pass a note object and a callback for function deleteNote
  NoteCard({required this.note, required this.deleteNote});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Slidable(
        actionPane: const SlidableScrollActionPane(),
        actions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red[500],
            icon: Icons.delete,
            /*
              executes deleteNote() if this Icon is clicked/tapped
              deleteNote implementation is dependent on the callback's implementation

            */
            onTap: () {
              deleteNote();
            },
          ),
        ],
        child: Card(
            child: Padding(
            padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    noteSubject,
                    style: TextStyle(
                      fontSize: defaultSubjectSize,
                      color: Colors.grey[900],
                    ),
                  ),
                  /*
                  * adds spacing
                  * */
                  const SizedBox(height: 6.0,),
                  Text(
                    noteNotes,
                    style: TextStyle(
                      fontSize: defaultNoteSize,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }
}