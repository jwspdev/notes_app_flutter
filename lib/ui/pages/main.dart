import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:notes_app/data/note.dart';
import 'package:notes_app/ui/widgets/note_card.dart';
import 'package:notes_app/ui/pages/add_edit_notes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //specify which widget is the home
      home: const NoteList(title: 'Notes'),
    );
  }
}

class NoteList extends StatefulWidget {
  const NoteList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  final defaultWidgetColor = Colors.yellow[700];
  List<Note> notesCreated = <Note>[] ;

  late final SharedPreferences sharedPreferences;

  /*
  * initial state of app
  * */
  @override
  void initState() {
    //initialize sharedPreferences before initializing the app
    initSharedPreferences();
    super.initState();
  }

  /*
  instantiates sharedPreferences
  waits until device gets the instance of shared preferences
  * */
  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //get data from sharedPreferences
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.black38
          ),
        ),
        centerTitle: true,
        backgroundColor: defaultWidgetColor,
      ),
      body: ListView.builder(
          itemCount: notesCreated.length,
          itemBuilder: (context, index){
            return InkWell(
              onLongPress: (){
                navigateToEditItemView(notesCreated[index]);
              },
              child: NoteCard(
                note: notesCreated[index],
                /*
                *
                * */
                deleteNote: (){
                  setState(() => removeNote(notesCreated[index]));
                },
              )
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        //built-in function for when the FAB is pressed/clicked
        onPressed: (){
          navigateToAddNotesPage();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: defaultWidgetColor,
      ),
    );
  }

  /*
    creates a list of strings
      elements: each note is converted into a map
    make it a list (.toList()) because map outputs an iterable
      saves the list of string in sharedPreferences with key of list
      access list of string by getting the string list with the key of list
  */
  void saveData(){
    List<String> sharedPrefList = notesCreated.map(
            (note) => json.encode(note.toMap())
    ).toList();
    sharedPreferences.setStringList('list', sharedPrefList);
    print(sharedPrefList);
  }
  /*
  * create a list of string:
  *   check if string list is present by passing the key from the created string list
  *   value = String of instances of each map
  * notesCreated:
  *   elements: decode each item from this list into a map,
  *             create a new Note object from the map
  * make it a list (.toList()) because map outputs an iterable
  *
  * notesCreated list elements are mapped instances of Note as note
  * note = decoded Note(subject: ['subjects'], notes: [notes])
  * */
  void loadData(){
    List<String>? sharedPrefList = sharedPreferences.getStringList('list');
    notesCreated = sharedPrefList!.map(
            (note) => Note.fromMap(json.decode(note))
    ).toList();
    print(sharedPrefList);
    setState(() {});
  }
  /*
  * navigate to AddEditNotesPage
  * navigator pushes this route to a created route for AddEditNotesPage()
  * waits for AddEditNotesPage is popped
  * then receive result(list of properties([<subject>,<notes>]) for a note) from AddEditNotesPage as noteItem
  * */
  void navigateToAddNotesPage(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return AddEditNotesPage();
    })).then((noteItem){
      if(noteItem != null){
        setState(() {
          /*
          * execute addNote
          * pass a new instance of Note(subject: noteItem[0], notes: noteItem[1])
          * check method comment for more info for noteItem[<index_number>]
          * */
          addNote(Note(subject: noteItem[0], notes: noteItem[1]));
        });
      }
    });
  }
  /*
  * navigate to AddEditNotesPage
  * param: dynamic note
  * navigator pushes this route to a created route for AddEditNotesPage(note)
  * waits for AddEditNotesPage is popped
  * then receive result(list of properties([<subject>,<notes>]) for a note) from AddEditNotesPage as noteItem
  * */
  void navigateToEditItemView(note){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return AddEditNotesPage(note: note,);
    })).then((noteItem){
      //check if noteItem (note list created from AddEditNotesPage) is not null
      if(noteItem != null){
        setState(() {
          /*
          * execute editNote
          * pass note, noteItem[0] = note.subject, and noteItem[1] = note.notes (check List of notes as result from AddEditNotesPage)
          * */
          editNote(note, noteItem[0], noteItem[1]);
        });
      }
    });
  }
  /*
  * param: note object
  * removes passed note from the list
  * */
  void removeNote(Note note){
    //removes
    notesCreated.remove(note);
    //saves data to sharePreferences
    saveData();
  }

  /*
  * param: note object
  * adds passed note to the list
  * */
  void addNote(Note note){

    notesCreated.add(note);
    //saves data to sharePreferences
    saveData();
  }

  /*
  * param: note object, String subject, String notes
  * edits/replaces the passed note object's properties to the passed string values respectively
  * */
  void editNote(Note note, String subject, String notes){
    note.subject = subject;
    note.notes = notes;
    //saves data to sharePreferences
    saveData();
  }
}

/*notesCreated.map((notes) => NoteCard(
                notes: notes,
                //callback to deleteNote function from NoteCard
                deleteNote: (){

                },
                //callback to editNote function from NoteCard
                editNote: (){

                }
            ),
            ).toList();
* */
