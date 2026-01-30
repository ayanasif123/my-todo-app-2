class NoteModel {
  int? id;
  String title;
  String note;
  String date;

  NoteModel({
    this.id,
    required this.title,
    required this.note,
    required this.date,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'], // ⚠️ must be 'id'
      title: map['title'],
      note: map['note'],
      date: map['date'],
    );
  }
}
