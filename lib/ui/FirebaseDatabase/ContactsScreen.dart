import 'package:contacts/ui/FirebaseDatabase/newContact.dart';
import 'package:contacts/ui/auth/login_screen.dart';
import 'package:contacts/utils/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../services/session.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final editNameController = TextEditingController();
  final editPhoneNumController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference databaseref =
      FirebaseDatabase.instance.ref(SessionController().userId);

  Future<void> showMyDialog(DataSnapshot snapshot) async {
    editNameController.text = snapshot.child("Name").value.toString();
    editPhoneNumController.text = snapshot.child("PhoneNum").value.toString();
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text("Update"),
            content: Container(
              height: 500,
              child: Column(children: [
                TextField(
                  controller: editNameController,
                  decoration: InputDecoration(hintText: "Edit Name"),
                ),
                TextField(
                  controller: editPhoneNumController,
                  decoration: InputDecoration(hintText: "Edit phone number"),
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    databaseref
                        .child(snapshot.child('Name').value.toString())
                        .update({
                      'PhoneNum': editPhoneNumController.text.toString(),
                      "Name": editNameController.text.toString()
                    }).then((value) {
                      Utils().toastMessage("Contact Updated ");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: Text("Update ")),
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
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
              icon: Icon(Icons.logout)),
          SizedBox(
            width: 10,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewContact()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [
        Expanded(
            child: FirebaseAnimatedList(
          query: databaseref,
          itemBuilder: (context, snapshot, animation, index) {
            return ListTile(
              title: Text(snapshot.child("Name").value.toString()),
              subtitle: Text(snapshot.child("PhoneNum").value.toString()),
              trailing: PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        // Perform edit action
                        showMyDialog(snapshot);
                      },
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        // Perform delete action
                        databaseref
                            .child(snapshot.child('Name').value.toString())
                            .remove()
                            .then((value) {})
                            .onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                        });
                      },
                      leading: Icon(Icons.delete_outline),
                      title: Text('Delete'),
                    ),
                  ),
                ],
              ),
            );
          },
        ))
      ]),
    );
  }
}


// required format of phone number