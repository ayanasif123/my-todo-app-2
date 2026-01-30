import 'package:flutter/material.dart';
import 'package:grid/My_model.dart';
import 'package:grid/db_helper.dart';
import 'package:intl/intl.dart';

class ViewNotesScreen extends StatefulWidget {
  const ViewNotesScreen({super.key});

  @override
  State<ViewNotesScreen> createState() => _ViewNotesScreenState();
}

class _ViewNotesScreenState extends State<ViewNotesScreen> {
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // Load notes from DB
  void loadNotes() async {
    final data = await DBHelper.getNotes();
    setState(() {
      notes = data.map((e) => NoteModel.fromMap(e)).toList();
    });
  }

  // Add or Edit note
  void addOrEditNote({NoteModel? note}) {
    TextEditingController titleController = TextEditingController(text: note?.title ?? '');
    TextEditingController noteController = TextEditingController(text: note?.note ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(hintText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: noteController, decoration: const InputDecoration(hintText: 'Note')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            child: Text(note == null ? 'Save' : 'Update'),
            onPressed: () async {
              if (titleController.text.isEmpty || noteController.text.isEmpty) return;

              String date = DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now());

              if (note == null) {
                await DBHelper.insertNote(titleController.text, noteController.text, date);
              } else {
                await DBHelper.updateNote(note.id!, titleController.text, noteController.text);
              }

              Navigator.pop(context);
              loadNotes(); // Refresh UI
            },
          ),
        ],
      ),
    );
  }

  // Delete note
  void deleteNote(int index) async {
    await DBHelper.deleteNote(notes[index].id!);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), backgroundColor: Colors.blueAccent),
      body: notes.isEmpty
          ? const Center(child: Text('No notes found', style: TextStyle(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(note.note, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(note.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => addOrEditNote(note: note)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => deleteNote(index)),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}