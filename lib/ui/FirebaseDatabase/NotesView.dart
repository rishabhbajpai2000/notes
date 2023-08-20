import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:contacts/ui/FirebaseDatabase/NewNote.dart';
import 'package:contacts/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../services/session.dart';
import '../auth/LoginScreen.dart';

class CompletedNotes extends StatefulWidget {
  const CompletedNotes({super.key});
  @override
  State<CompletedNotes> createState() => _CompletedNotesState();
}

class _CompletedNotesState extends State<CompletedNotes> {
  final editTitleController = TextEditingController();
  final editDescriptionController = TextEditingController();
  final dateController = TextEditingController();
  final priorityController = TextEditingController();
  int bottomNavIndex = 0;

  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference taskReference =
      FirebaseDatabase.instance.ref(SessionController().userId);

  Future<void> showUpdateDialog(DataSnapshot snapshot) async {
    editTitleController.text = snapshot.child("Title").value.toString();
    editDescriptionController.text =
        snapshot.child("Description").value.toString();
    dateController.text = snapshot.child("DueDate").value.toString();
    priorityController.text = snapshot.child("Priority").value.toString();

    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("Update"),
            content: SizedBox(
              height: 500,
              child: Column(children: [
                TextField(
                  controller: editTitleController,
                  decoration: const InputDecoration(
                      hintText: "Edit Title", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                            labelText: 'Due Date',
                            border: OutlineInputBorder()),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2021),
                            lastDate: DateTime(2024),
                          );

                          if (selectedDate != null) {
                            dateController.text =
                                selectedDate.toString().substring(0, 10);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: priorityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: editDescriptionController,
                  decoration: const InputDecoration(
                      hintText: "Edit Description",
                      border: OutlineInputBorder()),
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    taskReference
                        .child(snapshot.child("id").value.toString())
                        .update({
                      'Description': editDescriptionController.text.toString(),
                      "Title": editTitleController.text.toString(),
                      "DueDate": dateController.text.toString(),
                      "Priority": int.parse(priorityController.text)
                    }).then((value) {
                      Utils().toastMessage("Note Updated ");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text("Update ")),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [Icons.check_box, Icons.check_box_outline_blank];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Notes"),
        actions: [
          IconButton(
              onPressed: () {
                auth
                    .signOut()
                    .then((value) => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())))
                    .onError((error, stackTrace) =>
                        Utils().toastMessage(error.toString()));
              },
              icon: const Icon(Icons.logout)),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewNote()));
        },
        child: const Icon(Icons.add),
      ),
      body: completedTasks(),
    );
  }

  Column completedTasks() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FirebaseAnimatedList(
          query: taskReference.orderByChild("Priority"),
          itemBuilder: (context, snapshot, animation, index) {
            return ListTile(
              leading: Text(
                snapshot.child("Priority").value.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              title: Text(
                snapshot.child("Title").value.toString(),
                style: const TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due-Date: ${snapshot.child("DueDate").value}",
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    "Desc: ${snapshot.child("Description").value}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              trailing: PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      onTap: () {
                        taskReference
                            .child(snapshot.child("id").value.toString())
                            .update({"Completed": true}).then((value) {
                          Utils().toastMessage("Note Updated ");
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                        });
                      },
                      leading: const Icon(Icons.update),
                      title: const Text('Mark Completed'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        showUpdateDialog(snapshot);
                      },
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        // Perform delete action
                        taskReference
                            .child(snapshot.child('id').value.toString())
                            .remove()
                            .then((value) {})
                            .onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                        });
                      },
                      leading: const Icon(Icons.delete_outline),
                      title: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ))
    ]);
  }
}
