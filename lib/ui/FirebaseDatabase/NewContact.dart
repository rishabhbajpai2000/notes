import 'package:contacts/services/session.dart';
import 'package:contacts/utils/Utils.dart';
import 'package:contacts/widgets/RoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  bool loading = false;

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  DatabaseReference databaseref =
      FirebaseDatabase.instance.ref(SessionController().userId);

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile Number is required';
    } else if (value.length != 10) {
      return 'Mobile Number must be of 10 digits';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          SizedBox(height: 30),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
                hintText: "Name ", border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: numberController,
            validator: (value) => validateMobile(value),
            decoration: InputDecoration(
                hintText: "Number", border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 30,
          ),
          RoundButton(
              title: "Add",
              onTap: () {
                Navigator.pop(context);
                databaseref.child(nameController.text.toString()).set({
                  "Name": nameController.text.toString(),
                  "PhoneNum": numberController.text.toString()
                }).then((value) {
                  Utils().toastMessage("Contact Added Succesfully");
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
