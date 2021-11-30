class Note{
  String? subject;
  String? notes;

  //constructor for creating note objects
  //param: this.<value> to specify the property once we create a new note object;
  //eg: Notes(subject: <subject_value>, note: <note_value>);
  Note({this.subject, this.notes});

  //retrieves values of keys subject and notes from a map and store it as the properties subject and notes
  Note.fromMap(Map map) :
        subject = map['subject'],
        notes = map['notes'];

  //returns saved values of properties as maps with keys subject and notes respectively
  Map toMap(){
    return {
      "subject": subject,
      "notes": notes
    };
  }
}