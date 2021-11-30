import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notes_app/data/note.dart';

class AddEditNotesPage extends StatefulWidget{
  Note? note;

  AddEditNotesPage({this.note});

  @override
  _AddEditNotesPageState createState()=> _AddEditNotesPageState();
}

class _AddEditNotesPageState extends State<AddEditNotesPage>{

  final defaultWidgetColor = Colors.yellow[700];
  late TextEditingController subjectTextController;
  late TextEditingController notesTextController;

  late bool checkNoteInstance;
  //initializes current root widget
  //controllers' text is either notes properties or null
  @override
  void initState() {
    super.initState();
    checkNoteInstance = (widget.note != null);

    subjectTextController = TextEditingController(
      text: checkNoteInstance? widget.note!.subject :null
    );
    notesTextController = TextEditingController(
      text: checkNoteInstance? widget.note!.notes: null
    );
  }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          /*check if there are no instances of note
            value changes the the title of appbar
          */
          checkNoteInstance? 'Edit Note': 'Add Note',
        ),
        centerTitle: true,
        backgroundColor: defaultWidgetColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //textField of note subject
            TextField(
              //specify controller
              controller: subjectTextController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            //textField of note notes
            TextField(
              controller: notesTextController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              autofocus: true,
              onSubmitted: (value) => saveNote(),
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 14.0),
            ElevatedButton(
              onPressed: (){
                saveNote();
              },
              child: const Text(
                'Save Notes',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
  /*
  Saves texts from controllers to a list of string
  */
  void saveNote(){
    List<String> list = <String>[];
    list.add(subjectTextController.text);
    list.add(notesTextController.text);
    // Close the screen (pops this current page to the route stack)
    // returns the list as a result
    Navigator.pop(context, list);
  }
}