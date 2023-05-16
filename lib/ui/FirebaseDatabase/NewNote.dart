import 'package:contacts/services/session.dart';
import 'package:contacts/utils/Utils.dart';
import 'package:contacts/widgets/RoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  bool loading = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _priorityController = TextEditingController();

  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref(SessionController().userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          SizedBox(height: 30),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
                hintText: "Title ", border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                      labelText: 'Due Date', border: OutlineInputBorder()),
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2024),
                    );

                    if (selectedDate != null) {
                      _dateController.text =
                          selectedDate.toString().substring(0, 10);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _priorityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Priority (1-5)',
                      border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 100,
            child: TextFormField(
              controller: descriptionController,
              expands: true,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  hintText: "Description ", border: OutlineInputBorder(),),
            ),
          ),
         // Expanded(child: Column()),
          SizedBox(height: 30,),
          RoundButton(
              title: "Add",
              onTap: () {
                Navigator.pop(context);
                String id  = DateTime.now().millisecondsSinceEpoch.toString();
                // True and false denote the completeness of the task.
                databaseRef.child(id).set({
                  "id":id,
                  "Title": titleController.text.toString(),
                  "Description": descriptionController.text.toString(),
                  "DueDate": _dateController.text.toString(),
                  "Priority": int.parse(_priorityController.text),
                  "Completed": false
                }).then((value) {
                  Utils().toastMessage("Contact Added Successfully");
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              }),
        ]),
      ),
    );
  }
}
